{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.h-acer = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.h-acer
      inputs.sops-nix.nixosModules.sops
      inputs.neovim.nixosModules.neovim
      self.nixosModules.homelab
    ];
  };

  flake.nixosModules.h-acer = {pkgs, ...}: {
    wrappers.neovim.enable = true;

    nixpkgs.overlays = [
      (_final: prev: {
        jellyfin-web = prev.jellyfin-web.overrideAttrs (
          _finalAttrs: _previousAttrs: {
            installPhase = ''
              runHook preInstall

              # this is the important line
              sed -i "s#</head>#<script src=\"configurationpage?name=skip-intro-button.js\"></script></head>#" dist/index.html

              mkdir -p $out/share
              cp -a dist $out/share/jellyfin-web

              runHook postInstall
            '';
          }
        );
      })
    ];

    sops = {
      defaultSopsFile = ./secrets.yaml;
      age.keyFile = "/var/lib/sops-nix/key.txt";

      secrets."wireguard/private_key" = {
        owner = "root";
        mode = "0400";
      };
      secrets."deluge/auth" = {
        owner = "root";
        mode = "0400";
      };
    };

    homelab.user.enable = true;
    homelab.services = {
      jellyfin.enable = true;
      audiobookshelf.enable = false;
      arr.enable = true;
      deluge.enable = true;
    };

    # sabnzbd?

    nix.settings.experimental-features = ["nix-command" "flakes"];

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "h-acer"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Europe/London";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_GB.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "gb";
      variant = "";
    };

    # Configure console keymap
    console.keyMap = "uk";

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.h = {
      isNormalUser = true;
      description = "h";
      extraGroups = ["networkmanager" "wheel" "optical"];
      packages = with pkgs; [];
    };

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
      makemkv
      wireguard-tools # for `wg show`
      iproute2 # for `ip netns exec`
      socat # for the web UI proxy
      gawk
      tcpdump
      ripgrep
    ];

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    programs.neovim.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    programs.git.enable = true;

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.11"; # Did you read the comment?
  };
}
