{
  inputs,
  self,
  ...
}: {
  flake.homeConfigurations.h-hp-pk = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
    modules = [
      self.homeModules.h-hp-pk
    ];
  };

  flake.homeModules.h-hp-pk = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      self.homeModules.user
      self.homeModules.niri-stack
    ];

    nixpkgs.config.allowUnfree = true;

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "26.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = [
      # Devtools
      pkgs.android-studio
      pkgs.android-tools
      # pkgs.python3
      pkgs.bear
      # pkgs.cargo
      pkgs.commitizen
      pkgs.unzip
      pkgs.zip

      # Command line
      pkgs.ncdu
      pkgs.imv
      pkgs.timewarrior
      pkgs.wayout
      pkgs.xlsclients

      # GUI
      pkgs.google-chrome
      pkgs.backintime
      pkgs.blueman
      # cura
      pkgs.diylc
      pkgs.freecad-wayland
      pkgs.gimp
      pkgs.guvcview
      pkgs.inkscape
      pkgs.kicad
      pkgs.librecad
      pkgs.libreoffice
      pkgs.openscad
      pkgs.pcmanfm
      pkgs.pinta
      pkgs.prusa-slicer
      pkgs.libsForQt5.qtstyleplugin-kvantum
      pkgs.wdisplays

      #audio
      pkgs.audacity
      pkgs.pwvucontrol
    ];

    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    home.file = {};

    home.sessionPath = [
      "$HOME/.local/bin"
    ];

    home.sessionVariables = {
      VISUAL = "vim";
      BROWSER = "firefox";
    };

    programs.browserpass = {
      enable = true;
      browsers = ["firefox"];
    };

    # programs.git = {
    #   enable = true;
    #   lfs.enable = true;
    #   settings = {
    #     user.name = "Harry Tunnicliffe";
    #     user.email = "harry.tunnicliffe@platformkinetics.com";
    #   };
    # };

    programs.home-manager.enable = true;

    programs.mpv.enable = true;

    programs.password-store.enable = true;

    programs.taskwarrior = {
      package = pkgs.taskwarrior3;
      enable = true;
      config = {
        hooks.location = "${config.home.homeDirectory}/.config/task/hooks";
      };
    };

    programs.zathura.enable = true;

    targets.genericLinux.nixGL = {
      packages = inputs.nixGL.packages; # you must set this or everything will be a noop
      defaultWrapper = "mesa"; # choose from nixGL options depending on GPU
    };

    programs.noctalia-shell = {
      package = config.lib.nixGL.wrap pkgs.noctalia-shell;
    };

    wm.niri.chat-app = {
      pkg = "slack";
      app_id = "slack";
    };

    programs.bash = {
      enable = true;
      shellAliases = {
        jn = "pipenv run jupyter lab";
        idf = "source /home/h/.espressif/tools/activate_idf_v6.0.sh";
      };
    };
  };
}
