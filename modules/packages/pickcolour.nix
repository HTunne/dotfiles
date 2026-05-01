{
  perSystem = {pkgs, ...}: {
    packages.pickcolour = pkgs.writeShellApplication {
      name = "pickcolour";
      runtimeInputs = [pkgs.grim pkgs.slurp pkgs.imagemagick pkgs.wl-clipboard];
      text = ''
        grim -g "$(slurp -p)" -t ppm - | magick - -format '%[hex:p{0,0}]' info:- | wl-copy
      '';
    };
  };
}
