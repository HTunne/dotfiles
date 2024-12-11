{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (config.catppuccin) sources;
  cfg = config.catppuccin;
  palette = (lib.importJSON "${sources.palette}/palette.json").${cfg.flavor}.colors;
  myfont = "DejaVuSansM Nerd Font Mono";
in {
  home.packages = with pkgs; [
    # For DE
    nerd-fonts.dejavu-sans-mono
    nerd-fonts.droid-sans-mono
    bemenu
    libnotify
    swaybg
    imagemagick
    slurp
    grim
    swappy
    wl-clipboard
    networkmanager_dmenu
    # udisks

    (writeShellApplication {
      name = "grimwrap";
      runtimeInputs = [grim slurp wl-clipboard swappy imagemagick];
      text = ''
        inopt=$(echo -e "Fullscreen\nSelect" | bemenu "$@" -p 'Screenshot input')
        outopt=$(echo -e "Save\nCopy\nEdit" | bemenu "$@" -p 'Screenshot output')
        case $inopt in
          Fullscreen)
            case $outopt in
              Save) grim "$HOME"/pics/scrns/"$(date -u +%Y-%m-%d-%H-%M-%S-%N)".png;;
              Copy) grim - | convert - -shave 1x1 PNG:- | wl-copy;;
              Edit) grim - | swappy -f -;;
            esac
           ;;
          Select)
            case $outopt in
              Save) slurp | grim -g - "$HOME"/pics/scrns/"$(date -u +%Y-%m-%d-%H-%M-%S-%N)".png;;
              Copy) slurp | grim -g - - | convert - -shave 1x1 PNG:- | wl-copy;;
              Edit) slurp | grim -g - - | swappy -f -;;
            esac
            ;;
        esac
      '';
    })

    (writeShellApplication {
      name = "pass-menu";
      runtimeInputs = [bemenu];
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
      runtimeInputs = [bemenu];
      text = ''
        choice=$(echo -e "Shutdown\nLogout\nReboot" | bemenu "$@" -p power)
        case $choice in
          Shutdown) poweroff;;
          Reboot) reboot;;
          Logout) hyprctl dispatch exit 1;;
        esac
      '';
    })
  ];

  programs.bottom.enable = true;

  programs.bemenu = {
    enable = true;
    settings = {
      line-height = 22;
      prompt = "open";
      ignorecase = true;
      fn = "${myfont} 10";
      ff = "${palette.text.hex}";
      fb = "${palette.base.hex}";
      nf = "${palette.text.hex}";
      nb = "${palette.base.hex}";
      tf = "${palette.teal.hex}";
      tb = "${palette.base.hex}";
      hf = "${palette.teal.hex}";
      hb = "${palette.base.hex}";
      af = "${palette.text.hex}";
      ab = "${palette.base.hex}";
      hp = 8;
      ch = 16;
      cw = 2;
      width-factor = 1;
    };
  };

  services.batsignal.enable = true;

  services.gammastep = {
    enable = true;
    latitude = 0.1;
    longitude = 55.1;
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  services.unclutter.enable = true;

  services.dunst = {
    enable = true;
    settings = {
      global = {
        separator_color = "frame";
        offset = "0x0";
        font = "${myfont} 10";
        frame_width = 1;
      };
    };
  };

  xdg.configFile."networkmanager-dmenu/config.ini".text = ''
    [dmenu]
    compact=True
    dmenu_command='bemenu'
    [editor]
    terminal='foot'
  '';
}
