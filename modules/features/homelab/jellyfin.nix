{
  flake.nixosModules.homelab = {
    pkgs,
    lib,
    config,
    ...
  }: {
    # nixpkgs.overlays = [
    #   (_final: prev: {
    #     jellyfin-web = prev.jellyfin-web.overrideAttrs (
    #       _finalAttrs: _previousAttrs: {
    #         installPhase = ''
    #           runHook preInstall
    #
    #           # this is the important line
    #           sed -i "s#</head>#<script src=\"configurationpage?name=skip-intro-button.js\"></script></head>#" dist/index.html
    #
    #           mkdir -p $out/share
    #           cp -a dist $out/share/jellyfin-web
    #
    #           runHook postInstall
    #         '';
    #       }
    #     );
    #   })
    # ];
    #
    options.homelab.services.jellyfin = {
      enable = lib.mkEnableOption {
        description = "Whether to enable arr stack";
      };
    };
    config = lib.mkIf config.homelab.services.jellyfin.enable {
      services.jellyfin = {
        enable = true;
        openFirewall = true;
        user = config.homelab.user.user;
        group = config.homelab.user.group;
      };
    };
  };
}
