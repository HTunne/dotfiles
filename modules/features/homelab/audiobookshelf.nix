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
    config = lib.mkdIf config.homelab.services.audiobookshelf.enable {
      services.audiobookshelf = {
        enable = true;
        user = config.homelab.user;
        group = config.homelab.group;
      };
    };
  };
}
