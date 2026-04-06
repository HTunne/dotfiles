{
  flake.nixosModules.homelab = {
    lib,
    config,
    ...
  }: {
    options.homelab.user = {
      enable = lib.mkEnableOption {
        description = "Whether to enable homelab user";
      };
      user = lib.mkOption {
        default = "share";
        type = lib.types.str;
        description = ''
          User to run the homelab services as
        '';
      };
      group = lib.mkOption {
        default = "share";
        type = lib.types.str;
        description = ''
          Group to run the homelab services as
        '';
      };
    };
    config = lib.mkIf config.homelab.user.enable {
      users = {
        groups.${config.homelab.user.group} = {
          gid = 992;
        };
        users.${config.homelab.user.user} = {
          uid = 994;
          isSystemUser = true;
          group = config.homelab.user.group;
        };
      };
    };
  };
}
