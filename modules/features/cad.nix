{
  flake.homeModules.cad = {pkgs, ...}: {
    home.packages = with pkgs; [
      diylc
      cura
      freecad
      kicad
      librecad
      openscad
      prusa-slicer
      veroroute
    ];
  };
}
