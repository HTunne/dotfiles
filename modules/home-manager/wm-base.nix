{ config, pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    # For DE
    (nerdfonts.override { fonts = [ "DejaVuSansMono" ]; })
    bemenu
    libnotify
    swaybg
    imagemagick
    slurp
    grim
    swappy
    wl-clipboard
    # udisks

    (writeShellApplication {
      name = "grimwrap";
      runtimeInputs = [ grim slurp wl-clipboard swappy imagemagick ];
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
  ];

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

  programs.bottom.enable = true;
}
