{inputs, ...}: {
  flake.nixosModules.proaudio = {pkgs, ...}: {
    imports = [
      inputs.musnix.nixosModules.musnix
    ];
    musnix.enable = true;

    environment.systemPackages = [
      #audio
      pkgs.qpwgraph
      pkgs.ardour
      pkgs.audacity
      pkgs.AMB-plugins
      pkgs.bespokesynth
      pkgs.cardinal
      pkgs.caps
      pkgs.bchoppr
      pkgs.dexed
      # pkgs.distrho
      pkgs.dragonfly-reverb
      # pkgs.helm
      pkgs.hydrogen
      pkgs.lsp-plugins
      pkgs.neural-amp-modeler-lv2
      pkgs.pwvucontrol
      pkgs.tap-plugins
      pkgs.vmpk
      pkgs.wolf-shaper
      pkgs.x42-avldrums
      pkgs.x42-plugins
      pkgs.yoshimi
      pkgs.zam-plugins
    ];
  };
}
