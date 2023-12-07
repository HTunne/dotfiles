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
  myfont = "DejaVuSansM Nerd Font Mono";
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
    # For DE
    (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; })
    bemenu
    libnotify
    light
    swaybg
    wl-clipboard

    # Devtools
    bear
    cargo
    commitizen
    gcc
    gnumake
    nodejs
    python3
    unzip
    zip

    # Command line
    fd
    R
    ripgrep
    sxiv
    wget

    # GUI
    ardour
    blueman
    gimp
    kicad
    openscad
    pcmanfm
    timeshift

    (writeShellApplication {
      name = "pass-menu";
      runtimeInputs = [ bemenu ];
      text = ''
        pushd "$PASSWORD_STORE_DIR" || exit
        password=$(fd --extension gpg | sed 's/\.gpg//' | bemenu -p pass "$@")
        [[ -n $password ]] || exit
        pass show -c "$password" 2>/dev/null
        popd >/dev/null 2>&1
      '';
    })

    (writeShellApplication {
      name = "powermenu";
      runtimeInputs = [ bemenu ];
      text = ''
        choice=$(echo -e "Shutdown\nLogout\nReboot" | bemenu "$@" -p 'Power')
        case $choice in
          Shutdown) poweroff;;
          Reboot) reboot;;
          Logout) qtile cmd-obj -o cmd -f shutdown;;
        esac
      '';
    })

    (writeShellApplication {
      name = "ex";
      runtimeInputs = [ gnutar bzip2 unrar gzip unzip p7zip ];
      text = ''
        if [ -f "$1" ] ; then
          case $1 in
            *.tar.bz2)   tar xjf "$1"   ;;
            *.tar.gz)    tar xzf "$1"   ;;
            *.bz2)       bunzip2 "$1"   ;;
            *.rar)       unrar x "$1"   ;;
            *.gz)        gunzip "$1"    ;;
            *.tar)       tar xf "$1"    ;;
            *.tbz2)      tar xjf "$1"   ;;
            *.tgz)       tar xzf "$1"   ;;
            *.zip)       unzip "$1"     ;;
            *.Z)         uncompress "$1";;
            *.7z)        7z x "$1"      ;;
            *)           echo "'$1' cannot be extracted via ex" ;;
          esac
        else
          echo "'$1' is not a valid file"
        fi
      '';
    })
  ];

  home.file = { };

  home.sessionVariables = {
    TERMINAL = "alacritty";
    VISUAL = "nvim";
    BROWSER = "firefox";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    MOZ_ENABLE_WAYLAND = 1;
    BEMENU_OPTS = "--fb ${mocha.base} --ff ${mocha.text} --nb ${mocha.base} "
      + "--nf ${mocha.text} --tf ${mocha.base} --hf ${mocha.base} --tb ${mocha.teal} "
      + "--hb ${mocha.teal} --nf ${mocha.text} --af ${mocha.text} --ab ${mocha.base} "
      + "-H 24 --hp 8 --ch 16 --cw 2 --fn '${myfont} 10'";
  };

  services.batsignal.enable = true;

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

  services.gammastep = {
    enable = true;
    latitude = 0.1;
    longitude = 55.1;
  };

  services.unclutter.enable = true;

  imports = [ inputs.xremap-flake.homeManagerModules.default ];
  services.xremap = {
    # withWlroots = true;
    withX11 = true;
    config = {
      keymap = [
        {
          name = "bemenu";
          remap = {
            leftalt-p = {
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
          footer_bar = {
            foreground = "${mocha.base}";
            background = "${mocha.subtext0}";
          };
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

  programs.bat.enable = true;

  programs.bash = {
    enable = true;
    shellAliases = {
      more = "less";
      mnt = "udisksctl mount -b";
      umnt = "udisksctl unmount -b";
      ssh = "TERM=xterm-256color ssh";
      ls = "exa --git";
      la = "exa -a --git";
      ll = "exa -l --git";
      lt = "exa -l -snew --git";
      lr = "exa -l --tree --level=3 --git";
      tree = "exa -l --tree --git";
      cdg = "cd $\(git rev-parse --show-toplevel\)";
      calc = "R --no-save -q";
    };
    shellOptions = [
      "histappend"
      "checkwinsize"
      "extglob"
      "globstar"
      "checkjobs"
    ];
    initExtra = "set -o vi";
  };

  programs.bottom.enable = true;

  programs.eza = {
    enable = true;
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
      search.default = "DuckDuckGo";
    };
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "HTunne";
    userEmail = "hazzatun@gmail.com";
  };

  programs.home-manager.enable = true;

  programs.mcfly = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.mpv.enable = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [ nvim-treesitter.withAllGrammars ];
  };

  programs.password-store.enable = true;

  programs.ssh = {
    enable = true;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.tealdeer.enable = true;

  programs.zathura.enable = true;

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    options = [ "--cmd" "cd" ];
  };

  xdg.configFile = {
    nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/config/nvim";
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

  wayland.windowManager.hyprland = {
    # Whether to enable Hyprland wayland compositor
    enable = true;
    # The hyprland package to use
    package = pkgs.hyprland;
    # Whether to enable XWayland
    xwayland.enable = true;

    # Optional
    # Whether to enable hyprland-session.target on hyprland startup
    systemd.enable = true;
    # Whether to enable patching wlroots for better Nvidia support
    enableNvidiaPatches = true;
  };
}
