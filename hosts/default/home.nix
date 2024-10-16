{ config, pkgs, inputs, ... }:
let
  mocha = {
    rosewater = "#f5e0dc";
    flamingo = "#f2cdcd";
    pink = "#f5c2e7";
    mauve = "#cba6f7";
    red = "#f38ba8";
    maroon = "#eba0ac";
    peach = "#fab387";
    yellow = "#f9e2af";
    green = "#a6e3a1";
    teal = "#94e2d5";
    sky = "#89dceb";
    sapphire = "#74c7ec";
    blue = "#89b4fa";
    lavender = "#b4befe";
    text = "#cdd6f4";
    subtext1 = "#bac2de";
    subtext0 = "#a6adc8";
    overlay2 = "#9399b2";
    overlay1 = "#7f849c";
    overlay0 = "#6c7086";
    surface2 = "#585b70";
    surface1 = "#45475a";
    surface0 = "#313244";
    base = "#1e1e2e";
    mantle = "#181825";
    crust = "#11111b";
  };
  mocha2 = import ./mocha.nix;
  myfont = "DejaVuSansM Nerd Font Mono";

  /* 
    pkgs.overlays = pkgs.overlays ++ [
    (final: prev: {
    hello = prev.hello.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
    install ext/on-modify.timewarrior "${config.home.homeDirectory}/.config/task/hooks/";
    '';
    });
    })
    ];
  */
in
{
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
    cmake
    gcc
    gnumake
    nodejs
    python3
    unzip
    zip

    # Command line
    diskonaut
    pqiv
    timewarrior
    wayout
    xorg.xlsclients

    # NVIM
    # bash
    nodePackages.bash-language-server
    shfmt
    # c/c++
    clang-tools
    # cmake
    cmake-language-server
    cmake-format
    # js/ts
    nodePackages.typescript-language-server
    tailwindcss-language-server
    prettierd
    # lua
    lua-language-server
    selene
    stylua
    # nix
    # rnix-lsp
    # openscad
    openscad-lsp
    # python
    python311Packages.python-lsp-server
    python311Packages.flake8
    yapf
    isort
    python311Packages.vulture
    # vue
    nodePackages.vue-language-server

    tree-sitter

    # GUI
    arduino
    google-chrome
    backintime
    blueman
    # cura
    diylc
    discord
    freecad
    gimp
    guvcview
    inkscape
    kanshi
    python311Packages.kicad
    librecad
    libreoffice
    openscad
    pcmanfm
    pinta
    prusa-slicer
    libsForQt5.qtstyleplugin-kvantum
    steam
    wdisplays

    #audio
    qpwgraph
    ardour
    audacity
    AMB-plugins
    avldrums-lv2
    bespokesynth
    calf
    cardinal
    caps
    bchoppr
    dexed
    distrho
    dragonfly-reverb
    helm
    hydrogen
    pwvucontrol
    tap-plugins
    vmpk
    wolf-shaper
    yoshimi
    zam-plugins

  ];

  home.file = { };

  home.sessionVariables = {
    TERMINAL = "alacritty";
    VISUAL = "nvim";
    BROWSER = "firefox";
    QT_QPA_PLATFORM = "wayland";
    # QT_QPA_PLATFORMTHEME = "qt5ct";
    MOZ_ENABLE_WAYLAND = 1;
    BEMENU_OPTS = "--fb ${mocha2.base} --ff ${mocha.text} --nb ${mocha.base} "
      + "--nf ${mocha.text} --tf ${mocha.base} --hf ${mocha.base} --tb ${mocha.teal} "
      + "--hb ${mocha.teal} --nf ${mocha.text} --af ${mocha.text} --ab ${mocha.base} "
      + "-H 24 --hp 8 --ch 16 --cw 2 --fn '${myfont} 10'";
  };

  gtk = {
    enable = true;
    font.name = "DejaVuSansM Nerd Font 14";
    theme = {
      name = "Catppuccin-Mocha-Compact-Teal-Dark";
      package = pkgs.catppuccin-gtk.override {
        variant = "mocha";
        accents = [ "teal" ];
        tweaks = [ "normal" ];
        size = "compact";
      };
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders;
    };
    # Where we define the cursor
    cursorTheme.name = "macOS-BigSur";

    gtk3.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
    gtk4.extraConfig = {
      Settings = ''
        gtk-application-prefer-dark-theme=1
      '';
    };
  };
  qt = {
    enable = true;
    style = {
      name = "kvantum";
      package = pkgs.catppuccin-kvantum.override {
        variant = "Mocha";
        accent = "Green";
      };
    };
    platformTheme.name = "gtk";
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        frame_color = "${mocha.blue}";
        separator_color = "frame";
        offset = "0x24";
        font = "${myfont}";
      };
      urgency_low = {
        background = "${mocha.base}";
        foreground = "${mocha.text}";
      };
      urgency_normal = {
        background = "${mocha.base}";
        foreground = "${mocha.text}";
      };
      urgency_critical = {
        background = "${mocha.base}";
        foreground = "${mocha.text}";
        frame_color = "${mocha.peach}";
      };
    };
  };

  imports = [ inputs.xremap-flake.homeManagerModules.default ];
  services.xremap = {
    withWlroots = true;
    # withX11 = true;
    config = {
      keymap = [
        {
          name = "bemenu";
          remap = {
            super-p = {
              launch = [ "bemenu-run" ];
            };
          };
        }
      ];
    };
  };

  programs.alacritty = {
    enable = true;
    settings = {
      font.normal.family = "${myfont}";
      colors = {
        primary = {
          background = "${mocha.base}";
          foreground = "${mocha.text}";
          # Bright and dim foreground colors
          dim_foreground = "${mocha.text}";
          bright_foreground = "${mocha.text}";
        };

        # Cursor colors
        cursor = {
          text = "${mocha.base}";
          cursor = "${mocha.rosewater}";
        };
        vi_mode_cursor = {
          text = "${mocha.base}";
          cursor = "${mocha.lavender}";
        };

        # Search colors
        search = {
          matches = {
            foreground = "${mocha.base}";
            background = "${mocha.subtext0}";
          };
          focused_match = {
            foreground = "${mocha.base}";
            background = "${mocha.green}";
          };
        };

        footer_bar = {
          foreground = "${mocha.base}";
          background = "${mocha.subtext0}";
        };

        # Keyboard regex hints
        hints = {
          start = {
            foreground = "${mocha.base}";
            background = "${mocha.yellow}";
          };
          end = {
            foreground = "${mocha.base}";
            background = "${mocha.subtext0}";
          };
        };

        # Selection colors
        selection = {
          text = "${mocha.base}";
          background = "${mocha.rosewater}";
        };

        # Normal colors
        normal = {
          black = "${mocha.surface1}";
          red = "${mocha.red}";
          green = "${mocha.green}";
          yellow = "${mocha.yellow}";
          blue = "${mocha.blue}";
          magenta = "${mocha.pink}";
          cyan = "${mocha.teal}";
          white = "${mocha.subtext1}";
        };

        # Bright colors
        bright = {
          black = "${mocha.surface2}";
          red = "${mocha.red}";
          green = "${mocha.green}";
          yellow = "${mocha.yellow}";
          blue = "${mocha.blue}";
          magenta = "${mocha.pink}";
          cyan = "${mocha.teal}";
          white = "${mocha.subtext0}";
        };

        # Dim colors
        dim = {
          black = "${mocha.surface1}";
          red = "${mocha.red}";
          green = "${mocha.green}";
          yellow = "${mocha.yellow}";
          blue = "${mocha.blue}";
          magenta = "${mocha.pink}";
          cyan = "${mocha.teal}";
          white = "${mocha.subtext1}";
        };

        # indexed_colors = {
        # "- { index: 16, color: \"${mocha.peach}\" }";
        # "- { index: 17, color: \"${mocha.rosewater}\" }";
        # };
      };
    };
  };

  programs.firefox = {
    enable = true;
    profiles.h = {
      bookmarks = [
        {
          name = "toolbar";
          toolbar = true;
          bookmarks = [
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
      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        adnauseam
        darkreader
        duckduckgo-privacy-essentials
        firefox-color
        passff
        tridactyl
      ];
      search = {
        default = "DuckDuckGo";
        force = true;
      };
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "HTunne";
    userEmail = "hazzatun@gmail.com";
  };

  programs.home-manager.enable = true;

  programs.mpv.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

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

  xdg.configFile = {
    nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/dotfiles/nvim";
  };

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
}
