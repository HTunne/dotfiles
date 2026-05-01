{
  flake.homeModules.wm-base = {
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.droid-sans-mono
      libnotify
      swappy
      wl-clipboard
      # udisks
    ];

    programs.bat.enable = true;

    programs.bottom.enable = true;

    services.batsignal.enable = true;

    services.gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-qt;
    };

    services.unclutter.enable = true;

    services.kanshi = {
      enable = true;

      settings = [
        {
          profile.name = "undocked";
          profile.outputs = [
            {
              criteria = "eDP-1";
              scale = 1.0;
              status = "enable";
            }
          ];
        }
        {
          profile.name = "docked";
          profile.outputs = [
            {
              criteria = "eDP-1";
              status = "disable";
            }
            {
              criteria = "*";
              status = "enable";
            }
          ];
        }
      ];
    };
  };
}
