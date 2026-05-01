{
  inputs,
  self,
  ...
}: {
  flake.homeConfigurations.h-think = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
    modules = [
      self.homeModules.h-think
    ];
  };

  flake.homeModules.h-think = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      self.homeModules.user
      self.homeModules.cad
      self.homeModules.niri-stack
    ];
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
    home.packages = with pkgs; [
      # Command line
      imv
      timewarrior
      yt-dlp
      xlsclients

      # GUI
      arduino
      # google-chrome
      backintime
      blueman
      # calibre
      discord
      gimp
      guvcview
      inkscape
      libreoffice
      openscad
      pcmanfm
      pika-backup
      pinta
      libsForQt5.qtstyleplugin-kvantum
      steam
      wdisplays
    ];

    nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

    home.file = {};

    home.sessionVariables = {
      TERMINAL = "foot";
      VISUAL = "nvim";
      BROWSER = "firefox";
    };

    programs.home-manager.enable = true;

    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          normal.family = "DejaVuSansM Nerd Font Mono";
          size = 10;
        };
      };
    };

    programs.browserpass = {
      enable = true;
      browsers = ["firefox"];
    };

    programs.firefox = {
      enable = true;
      profiles.h = {
        bookmarks = {
          force = true;
          settings = [
            {
              name = "toolbar";
              toolbar = true;
              bookmarks = [
                {
                  name = "";
                  url = "http://homeassistant.local:8123";
                }
                {
                  name = "";
                  url = "https://mail.proton.me";
                }
                {
                  name = "";
                  url = "https://mail.google.com";
                }
                {
                  name = "";
                  url = "https://calendar.google.com";
                }
                {
                  name = "";
                  url = "https://drive.google.com";
                }
                {
                  name = "";
                  url = "https://www.youtube.com/";
                }
                {
                  name = "";
                  url = "https://open.spotify.com";
                }
                {
                  name = "";
                  url = "https://web.whatsapp.com";
                }
                {
                  name = "";
                  url = "https://www.messenger.com";
                }
                {
                  name = "";
                  url = "https://www.facebook.com";
                }
                {
                  name = "";
                  url = "https://github.com";
                }
                {
                  name = "";
                  url = "https://gitlab.com";
                }
                {
                  name = "";
                  url = "https://monkeytype.com";
                }
              ];
            }
          ];
        };
        extensions.packages = with inputs.firefox-addons.packages."x86_64-linux"; [
          adnauseam
          darkreader
          duckduckgo-privacy-essentials
          firefox-color
          passff
          tridactyl
        ];
        extensions.force = true;
        search = {
          default = "ddg";
          force = true;
        };
      };
    };

    programs.git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user.name = "HTunne";
        user.email = "hazzatun@gmail.com";
      };
    };

    programs.mpv.enable = true;

    programs.password-store = {
      enable = true;
      settings = {PASSWORD_STORE_DIR = "${config.xdg.dataHome}/password-store";};
    };

    programs.ssh = {
      enable = true;
    };

    programs.taskwarrior = {
      enable = true;
      config = {
        hooks.location = "${config.home.homeDirectory}/.config/task/hooks";
      };
    };

    programs.zathura.enable = true;

    xdg.userDirs.setSessionVariables = true;
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "$HOME/desk";
      documents = "$HOME/docs";
      download = "$HOME/dwns";
      music = "$HOME/mus";
      pictures = "$HOME/pics";
      publicShare = "$HOME/pub";
      templates = "$HOME/temp";
      videos = "$HOME/vids";
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
