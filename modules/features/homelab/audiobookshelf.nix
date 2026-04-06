{
  flake.nixosModules.homelab = {
    config,
    lib,
    ...
  }: {
    options.homelab.services.audiobookshelf = {
      enable = lib.mkEnableOption {
        description = "Whether to enable audiobookshelf";
      };
    };
    config = lib.mkIf config.homelab.services.audiobookshelf.enable {
      services.audiobookshelf = {
        enable = true;
        user = config.homelab.user.user;
        group = config.homelab.user.group;
      };
    };
  };
}
