{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.h-acer = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.h-acer
    ];
  };

  flake.nixosModules.h-acer = {pkgs, ...}: {
  };
}
