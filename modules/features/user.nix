{
  flake.homeModules.user = {
    lib,
    config,
    ...
  }: {
    options.preferences = {
      user.name = lib.mkOption {
        type = lib.types.str;
        default = "h";
      };
    };
    config = {
      home.username = config.preferences.user.name;
      home.homeDirectory = "/home/${config.preferences.user.name}";
    };
  };

  flake.nixosModules.user = {
    lib,
    config,
    ...
  }: {
    options.preferences = {
      user.name = lib.mkOption {
        type = lib.types.str;
        default = "h";
      };
    };
    config = {
      # users.defaultUserShell = self.packages.${pkgs.stdenv.hostPlatform.system}.zsh;
      users.users.${config.preferences.user.name} = {
        isNormalUser = true;
        extraGroups = ["networkmanager" "wheel" "audio" "video" "dialout" "docker"];
      };
    };
  };
}
