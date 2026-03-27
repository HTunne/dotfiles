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
      services.sonarr = {
        enable = true;
        user = config.homelab.user;
        group = config.homelab.group;
      };

      services.radarr = {
        enable = true;
        user = config.homelab.user;
        group = config.homelab.group;
      };

      services.readarr = {
        enable = true;
        user = config.homelab.user;
        group = config.homelab.group;
      };

      services.bazarr = {
        enable = true;
        user = config.homelab.user;
        group = config.homelab.group;
      };

      services.lidarr = {
        enable = true;
        user = config.homelab.user;
        group = config.homelab.group;
      };

      services.jellyseer = {
        enable = true;
        user = config.homelab.user;
        group = config.homelab.group;
      };
    };
  };
}
