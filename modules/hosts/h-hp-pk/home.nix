{
  inputs,
  self,
  ...
}: {
  flake.homeConfigurations.h-hp-pk = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {system = "x86_64-linux";};
    modules = [
      self.homeModules.h-hp-pk
      self.homeModules.shell
      self.homeModules.wm-base
      inputs.catppuccin.homeModules.catppuccin
      inputs.niri.homeModules.niri
      self.homeModules.niri
      inputs.neovim.homeModules.neovim
    ];
  };

  flake.homeModules.h-hp-pk = {
    config,
    pkgs,
    ...
  }: {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    home.username = "h";
    home.homeDirectory = "/home/h";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    home.stateVersion = "23.05"; # Please read the comment before changing.

    # The home.packages option allows you to install Nix packages into your
    # environment.
    home.packages = with pkgs; [
      # Devtools
      bear
      cargo
      commitizen
      unzip
      zip

      # Command line
      ncdu
      imv
      timewarrior
      wayout
      xlsclients

      # GUI
      google-chrome
      backintime
      blueman
      # cura
      diylc
      freecad-wayland
      gimp
      guvcview
      inkscape
      kicad
      librecad
      libreoffice
      openscad
      pcmanfm
      pinta
      prusa-slicer
      libsForQt5.qtstyleplugin-kvantum
      wdisplays

      #audio
      audacity
      pwvucontrol
    ];

    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    home.file = {};

    home.sessionPath = [
      "$HOME/.local/bin"
    ];

    home.sessionVariables = {
      TERMINAL = "foot";
      VISUAL = "nvim";
      BROWSER = "firefox";
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

    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          # shell = "${pkgs.nushell}/bin/nu";
          font = "DejaVuSansM Nerd Font Mono:size=10";
        };

        mouse = {
          hide-when-typing = "yes";
        };
      };
    };

    programs.browserpass = {
      enable = true;
      browsers = ["firefox"];
    };

    programs.git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user.name = "Harry Tunnicliffe";
        user.email = "harry.tunnicliffe@platformkinetics.com";
      };
    };

    programs.home-manager.enable = true;

    programs.mpv.enable = true;

    wrappers.neovim.enable = true;
    wrappers.neovim.settings.dev_mode = true;

    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
    };

    programs.password-store.enable = true;

    programs.ssh = {
      enable = true;
    };

    programs.taskwarrior = {
      package = pkgs.taskwarrior3;
      enable = true;
      config = {
        hooks.location = "${config.home.homeDirectory}/.config/task/hooks";
      };
    };

    programs.zathura.enable = true;

    catppuccin = {
      enable = true;
      flavor = "mocha";
      cursors.enable = true;
      cursors.accent = "teal";
      nvim.enable = false;
      kvantum.enable = false;
    };

    nixGL = {
      packages = inputs.nixGL.packages; # you must set this or everything will be a noop
      defaultWrapper = "mesa"; # choose from nixGL options depending on GPU
    };

    wayland.windowManager.hyprland = {
      package = config.lib.nixGL.wrap pkgs.hyprland;
      enable = true;
      settings = {
        "$mod" = "SUPER";
        bind = [
          "$mod, B, exec, thunderbird"
          "$mod SHIFT, B, exec, slack"
        ];
      };
    };

    programs.niri = {
      package = config.lib.nixGL.wrap pkgs.niri-unstable;
      settings = {
        binds = {
          "Mod+B".action.spawn = "thunderbird";
          "Mod+Shift+B".action.spawn = "slack";
        };
      };
    };

    programs.bash = {
      enable = true;
      shellAliases = {
        sxiv = "swayimg";
        jn = "pipenv run jupyter lab";
        idf = "source $HOME/src/espressif/esp-idf/export.sh";
      };
    };
  };
}
