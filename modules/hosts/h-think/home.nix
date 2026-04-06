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
      inputs.catppuccin.homeModules.catppuccin
      inputs.niri.homeModules.niri
      self.homeModules.user
      self.homeModules.wm-base
      self.homeModules.niri
      self.homeModules.cad
    ];
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

    gtk = {
      enable = true;
      font.name = "DejaVuSansM Nerd Font 14";
    };

    qt = {
      enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };

    programs.alacritty = {
      enable = true;
      settings = {
        font = {
          normal = "DejaVuSansM Nerd Font Mono";
          size = 10;
        };
      };
      # settings.shell.program = "${pkgs.nushell}/bin/nu";
    };

    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
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

    programs.home-manager.enable = true;

    programs.mpv.enable = true;


    programs.password-store.enable = true;

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

    catppuccin = {
      enable = true;
      flavor = "mocha";
      cursors.enable = true;
      cursors.accent = "teal";
      nvim.enable = false;
      kvantum.enable = false;
      hyprlock.useDefaultConfig = false;
    };
  };
}
