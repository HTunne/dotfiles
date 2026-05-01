{
  perSystem = {pkgs, lib, self', ...}: let
    walker = lib.getExe pkgs.walker;
    grim = lib.getExe pkgs.grim;
    slurp = lib.getExe pkgs.slurp;
    swappy = lib.getExe pkgs.swappy;
    magick = lib.getExe pkgs.imagemagick;
    jq = lib.getExe pkgs.jq;
    wl-copy = lib.getExe' pkgs.wl-clipboard wl-copy;
  in {
    packages.scrn-menu = pkgs.writeShellApplication {
      name = "scrn-menu";
      runtimeInputs = [pkgs.grim pkgs.slurp pkgs.wl-clipboard pkgs.swappy pkgs.imagemagick pkgs.jq pkgs.walker];
      text = ''
        inopt=$(echo -e "Fullscreen\nSelect\nActive" | ${walker} -d "$@" -p 'Screenshot input')
        outopt=$(echo -e "Save\nCopy\nEdit" | ${walker} -d "$@" -p 'Screenshot output')
        case $inopt in
          Fullscreen)
            case $outopt in
              Save) ${grim} "$HOME"/pics/scrns/"$(date -u +%Y-%m-%d-%H-%M-%S-%N)".png;;
              Copy) ${grim} - | ${magick} - -shave 1x1 PNG:- | ${wl-copy};;
              Edit) ${grim} - | ${swappy} -f -;;
            esac
           ;;
          Select)
            case $outopt in
              Save) ${slurp} | ${grim} -g - "$HOME"/pics/scrns/"$(date -u +%Y-%m-%d-%H-%M-%S-%N)".png;;
              Copy) ${slurp} | ${grim} -g - - | ${magick} - -shave 1x1 PNG:- | ${wl-copy};;
              Edit) ${slurp} | ${grim} -g - - | ${swappy} -f -;;
            esac
            ;;
          Active)
            case $outopt in
            # TODO: generalise selection
              Save) hyprctl -j activewindow | ${jq} -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | ${grim} -g - "$HOME"/pics/scrns/"$(date -u +%Y-%m-%d-%H-%M-%S-%N)".png;;
              Copy) hyprctl -j activewindow | ${jq} -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | ${grim} -g - - | ${magick} - -shave 1x1 PNG:- | ${wl-copy};;
              Edit) hyprctl -j activewindow | ${jq} -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | ${grim} -g - - | ${swappy} -f -;;
            esac
            ;;
        esac
      '';
    };
  };
}
