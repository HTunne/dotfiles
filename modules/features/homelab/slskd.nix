{
  flake.nixosModules.homelab = {config, ...}: {
    services.slskd = {
      enable = false;
      user = config.homelab.user.user;
      group = config.homelab.user.group;
    };
  };
}
