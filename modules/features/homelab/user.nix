{
  flake.nixosModules.homelab = {
    lib,
    config,
    ...
  }: {
    options.homelab = {
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
    config = lib.mkIf config.homelab.enable {
      users = {
        groups.${config.homelab.group} = {
          gid = 993;
        };
        users.${config.homelab.user} = {
          uid = 994;
          isSystemUser = true;
          group = config.homelab.group;
        };
      };
    };
  };
}
