{
  config,
  pkgs,
  inputs,
  nixGL,
  ...
}: let
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
in {
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
    python312Packages.qtile

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
    swayimg
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
    nixd
    alejandra
    # openscad
    openscad-lsp
    # python
    python311Packages.python-lsp-server
    python311Packages.flake8
    yapf
    isort
    python311Packages.vulture
    # typescript
    typescript-language-server
    # vue
    vscode-extensions.vue.volar

    tree-sitter

    # GUI
    arduino
    google-chrome
    backintime
    blueman
    # cura
    diylc
    freecad-wayland
    gimp
    guvcview
    inkscape
    python311Packages.kicad
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

  # programs.alacritty = {
  # enable = true;
  # settings.shell.program = "${pkgs.nushell}/bin/nu";
  # };

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
    userName = "Harry Tunnicliffe";
    userEmail = "harry.tunnicliffe@platformkinetics.com";
  };

  programs.home-manager.enable = true;

  programs.mpv.enable = true;

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

  xdg.configFile = {
    nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/dotfiles/nvim";
  };

  catppuccin = {
    enable = true;
    flavor = "mocha";
    cursors.enable = true;
    cursors.accent = "teal";
    nvim.enable = false;
    kvantum.enable = false;
  };

  nixGL = {
    packages = nixGL.packages; # you must set this or everything will be a noop
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

  programs.bash = {
    enable = true;
    shellAliases = {
      sxiv = "swayimg";
      jn = "pipenv run jupyter lab";
      idf = "source $HOME/src/espressif/esp-idf/export.sh";
    };
  };
}
