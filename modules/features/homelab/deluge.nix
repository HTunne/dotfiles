{
  flake.nixosModules.homelab = {
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
      services.deluge = {
        user = config.homelab.user;
        group = config.homelab.group;
        enable = true;
        web = {
          enable = true;
        };
      };
    };

    # systemd = lib.mkIf hl.services.wireguard-netns.enable {
    #   services.deluged.bindsTo = [ "netns@${ns}.service" ];
    #   services.deluged.requires = [
    #     "network-online.target"
    #     "${ns}.service"
    #   ];
    #   services.deluged.serviceConfig.NetworkNamespacePath = [ "/var/run/netns/${ns}" ];
    #   sockets."deluged-proxy" = {
    #     enable = true;
    #     description = "Socket for Proxy to Deluge WebUI";
    #     listenStreams = [ "58846" ];
    #     wantedBy = [ "sockets.target" ];
    #   };
    #   services."deluged-proxy" = {
    #     enable = true;
    #     description = "Proxy to Deluge Daemon in Network Namespace";
    #     requires = [
    #       "deluged.service"
    #       "deluged-proxy.socket"
    #     ];
    #     after = [
    #       "deluged.service"
    #       "deluged-proxy.socket"
    #     ];
    #     unitConfig = {
    #       JoinsNamespaceOf = "deluged.service";
    #     };
    #     serviceConfig = {
    #       User = config.services.deluge.user;
    #       Group = config.services.deluge.group;
    #       ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=5min 127.0.0.1:58846";
    #       PrivateNetwork = "yes";
    #     };
    #   };
    # };
  };
}
