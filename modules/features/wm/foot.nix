{
  flake.homeModules.foot = {
    home.sessionVariables = {
      TERMINAL = "foot";
    };

    programs.foot = {
      enable = true;
      server.enable = true;
      settings = {
        main = {
          font = "DejaVuSansM Nerd Font Mono:size=10";
          pad = "2x0 center";
        };

        mouse = {
          hide-when-typing = "yes";
        };
      };
    };
  };
}
