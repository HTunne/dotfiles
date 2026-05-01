{inputs, ...}: {
  flake.nixosModules.style = {
    imports = [
      inputs.catppuccin.nixosModules.catppuccin
    ];
    catppuccin = {
      enable = true;
      flavor = "mocha";
      # tty = {
        # enable = true;
      # };
    };
  };

  flake.homeModules.style = {
    imports = [
      inputs.catppuccin.homeModules.catppuccin
    ];
    catppuccin = {
      enable = true;
      flavor = "mocha";
      cursors.enable = true;
      cursors.accent = "teal";
      nvim.enable = false;
      kvantum.enable = false;
    };

    gtk = {
      enable = true;
      font.name = "DejaVuSansM Nerd Font 14";
    };

    qt = {
      enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };
  };
}
