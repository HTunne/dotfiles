{
  description = "My NixOs configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    catppuccin.url = "github:catppuccin/nix";
    musnix = {url = "github:musnix/musnix";};
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
    nixGL = {
      url = "github:nix-community/nixGL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {url = "github:sodiboo/niri-flake";};
  };

  outputs = {
    self,
    nixpkgs,
    catppuccin,
    niri,
    nixGL,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      config.nvidia.acceptLicense = true;
      overlays = [
        inputs.neovim-nightly-overlay.overlays.default
      ];
    };
  in {
    nixosConfigurations = {
      h-think = nixpkgs.lib.nixosSystem {
        inherit pkgs system;
        specialArgs = {inherit system inputs pkgs;};
        modules = [
          inputs.musnix.nixosModules.musnix
          ./hosts/h-think/configuration.nix
          catppuccin.nixosModules.catppuccin
          ./modules/nixos/battery.nix
        ];
      };
    };
    homeConfigurations = {
      h-think = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/h-think/home.nix
          catppuccin.homeManagerModules.catppuccin
          niri.homeModules.niri
          ./modules/home-manager/shell.nix
          ./modules/home-manager/wm-base.nix
          # ./modules/home-manager/hyprland.nix
          ./modules/home-manager/niri.nix
        ];
      };
      h-hp-pk = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {
          inherit inputs;
          inherit nixGL;
        };
        modules = [
          ./hosts/h-hp-pk/home.nix
          catppuccin.homeManagerModules.catppuccin
          niri.homeModules.niri
          ./modules/home-manager/shell.nix
          ./modules/home-manager/wm-base.nix
          # ./modules/home-manager/hyprland.nix
          ./modules/home-manager/niri.nix
        ];
      };
    };
  };
}
