{
  description = "My NixOs configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    musnix = { url = "github:musnix/musnix"; };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake.url = "github:xremap/nix-flake";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.nvidia.acceptLicense = true;
        overlays = [
          inputs.neovim-nightly-overlay.overlays.default
        ];
      };
    in
    {
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          inherit pkgs system;
          specialArgs = { inherit system inputs pkgs; };
          modules = [
            inputs.musnix.nixosModules.musnix
            ./hosts/default/configuration.nix
            ./modules/nixos/battery.nix
          ];
        };
      };
      homeConfigurations = {
        default = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./hosts/default/home.nix
            ./modules/home-manager/shell.nix
            ./modules/home-manager/wm-base.nix
          ];
        };
      };
    };
}
