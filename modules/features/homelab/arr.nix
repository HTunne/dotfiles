{
  flake.nixosModules.homelab = {
    lib,
    config,
    ...
  }: {
    options.homelab.services.arr = {
      enable = lib.mkEnableOption {
        description = "Whether to enable arr stack";
      };
    };
    config = lib.mkIf config.homelab.services.arr.enable {
      services.prowlarr = {
        enable = true;
        openFirewall = true;
      };

      services.sonarr = {
        enable = true;
        openFirewall = true;
        user = config.homelab.user.user;
        group = config.homelab.user.group;
      };

      services.radarr = {
        enable = true;
        openFirewall = true;
        user = config.homelab.user.user;
        group = config.homelab.user.group;
      };

      services.readarr = {
        enable = true;
        openFirewall = true;
        user = config.homelab.user.user;
        group = config.homelab.user.group;
      };

      services.bazarr = {
        enable = true;
        openFirewall = true;
        user = config.homelab.user.user;
        group = config.homelab.user.group;
      };

      services.lidarr = {
        enable = true;
        openFirewall = true;
        user = config.homelab.user.user;
        group = config.homelab.user.group;
      };

      services.seerr = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
