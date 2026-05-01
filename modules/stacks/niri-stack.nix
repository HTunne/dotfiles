{self, ...}: {
  flake.nixosModules.niri-stack = {
    imports = [
      self.nixosModules.niri
    ];
  };

  flake.homeModules.niri-stack = {
    imports = [
      self.homeModules.shell
      self.homeModules.wm-base
      self.homeModules.foot
      self.homeModules.niri
      self.homeModules.noctalia
      self.homeModules.style
      self.homeModules.walker
    ];
  };
}
