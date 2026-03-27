{
  flake.nixosModules.homelab = {config, ...}: {
    services.slskd = {
      enable = false;
      user = config.homelab.user;
      group = config.homelab.group;
    };
  };
}
