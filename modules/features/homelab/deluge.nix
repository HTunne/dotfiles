{
  flake.nixosModules.homelab = {
    pkgs,
    lib,
    config,
    ...
  }: {
    options.homelab.services.deluge = {
      enable = lib.mkEnableOption {
        description = "Whether to enable deluge";
      };
    };
    config = lib.mkIf config.homelab.services.deluge.enable {
      systemd.services.vpn-netns-setup = {
        description = "Set up vpn network namespace with WireGuard for Deluge";

        after = ["network-online.target"];
        wants = ["network-online.target"];
        wantedBy = ["multi-user.target"];
        before = ["deluged.service"];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStop = pkgs.writeShellScript "vpn-netns-teardown" ''
            # Bring down WireGuard
            ${pkgs.iproute2}/bin/ip -n vpn link del wg0 2>/dev/null || true
            # Remove the netns (also cleans up veth-vpn inside it)
            ${pkgs.iproute2}/bin/ip netns del vpn 2>/dev/null || true
            # Remove host side of veth
            ${pkgs.iproute2}/bin/ip link del veth-host 2>/dev/null || true
          '';
        };

        script = ''
          set -euo pipefail
          IP="${pkgs.iproute2}/bin/ip"
          WG="${pkgs.wireguard-tools}/bin/wg"

            # ---- 0. Clean up any leftover state from previous runs ----
          $IP netns del vpn 2>/dev/null || true
          $IP link del veth-host 2>/dev/null || true
          $IP link del wg0 2>/dev/null || true

          # ---- 1. Create the network namespace ----
          $IP netns add vpn 2>/dev/null || true

          # ---- 2. veth pair for host <-> netns (web UI access only) ----
          if ! $IP link show veth-host &>/dev/null; then
            $IP link add veth-host type veth peer name veth-vpn
          fi

          $IP link set veth-vpn netns vpn

          # Host side
          $IP addr add 10.200.200.1/24 dev veth-host 2>/dev/null || true
          $IP link set veth-host up

          # Netns side
          $IP -n vpn addr add 10.200.200.2/24 dev veth-vpn 2>/dev/null || true
          $IP -n vpn link set veth-vpn up
          $IP -n vpn link set lo up

          # ---- 3. Create WireGuard interface inside the netns ----
          $IP link add wg0 type wireguard
          $IP link set wg0 netns vpn

          # Configure WireGuard (reads private key from sops secret)
          $IP netns exec vpn $WG setconf wg0 /dev/stdin <<EOF
          [Interface]
          PrivateKey = $(cat ${config.sops.secrets."wireguard/private_key".path})

          [Peer]
          PublicKey = iJIw5umGxtrrSIRxVrSF1Ofu5IDphpBpAJOvsrG4FiI=
          Endpoint = 31.13.189.242:51820
          AllowedIPs = 0.0.0.0/0, ::/0
          PersistentKeepalive = 25
          EOF

          # Assign WireGuard IPs inside the netns
          $IP -n vpn addr add 10.2.0.2/32 dev wg0 2>/dev/null || true
          $IP -n vpn addr add 2a07:b944::2:2/128 dev wg0 2>/dev/null || true
          $IP -n vpn link set wg0 up
          $IP -n vpn link set wg0 mtu 1320

          # ---- 4. Routing inside the netns ----
          # Default route via WireGuard (all traffic exits through tunnel)
          $IP -n vpn route add default dev wg0 2>/dev/null || true

          # Keep veth reachable for web UI access from host
          # (the 10.200.200.0/24 connected route is added automatically)

          # ---- 5. DNS inside the netns ----
          mkdir -p /etc/netns/vpn
          echo "nameserver 10.2.0.1" > /etc/netns/vpn/resolv.conf

          echo "vpn netns ready — wg0 inside netns"
        '';
      };

      services.deluge = {
        user = config.homelab.user.user;
        group = config.homelab.user.group;
        enable = true;
        web.enable = true; # Web UI on port 8112 (accessible from host)
        # authFile = config.sops.secrets."deluge/auth".path;
      };

      # Override the deluged systemd unit to run in the vpn netns
      systemd.services.deluged = {
        after = ["vpn-netns-setup.service"];
        requires = ["vpn-netns-setup.service"];
        bindsTo = ["vpn-netns-setup.service"]; # Stop Deluge if netns goes away

        serviceConfig = {
          # This is the kill switch — deluged can ONLY use the vpn netns network
          NetworkNamespacePath = "/run/netns/vpn";
          Environment = "HOME=/var/lib/deluge";

          # Optional hardening
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectSystem = "strict";
          ReadWritePaths = ["/var/lib/deluge"];
          NoNewPrivileges = true;
        };
      };

      systemd.services.delugeweb = {
        after = ["vpn-netns-setup.service" "deluged.service"];
        requires = ["vpn-netns-setup.service"];
        serviceConfig = {
          NetworkNamespacePath = "/run/netns/vpn";
        };
      };

      systemd.services.deluge-web-proxy = {
        description = "Proxy localhost:8112 to Deluge web UI in vpn netns";
        after = ["delugeweb.service"];
        requires = ["delugeweb.service"];
        wantedBy = ["multi-user.target"];

        serviceConfig = {
          ExecStart = "${pkgs.socat}/bin/socat TCP-LISTEN:8112,fork,reuseaddr TCP:10.200.200.2:8112";
          Restart = "always";
          RestartSec = "5s";
        };
      };

      networking.firewall = {
        allowedTCPPorts = [8112]; # Deluge web UI
      };
    };
  };
}
