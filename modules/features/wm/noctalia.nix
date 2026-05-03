{inputs, ...}: {
  flake.homeModules.noctalia = {pkgs, ...}: {
    imports = [
      inputs.noctalia.homeModules.default
    ];
    home.packages = [
      (pkgs.writeShellApplication {
        name = "noctalia-diff";
        runtimeInputs = [pkgs.json-diff];
        text = ''
          json-diff <(jq -S . ~/.config/noctalia/settings.json) <(noctalia-shell ipc call state all | jq -S .settings)
        '';
      })
    ];

    # configure options
    programs.noctalia-shell = {
      enable = true;
      settings = {
        bar = {
          settingsVersion = 59;
          barType = "floating";
          position = "top";
          density = "compact";
          showCapsule = false;
          backgroundOpacity = 1;
          outerCorners = false;
          hideOnOverview = true;
          widgets = {
            "left" = [
              {
                "characterCount" = 2;
                "colorizeIcons" = false;
                "emptyColor" = "none";
                "enableScrollWheel" = true;
                "focusedColor" = "primary";
                "followFocusedScreen" = false;
                "fontWeight" = "bold";
                "groupedBorderOpacity" = 1;
                "hideUnoccupied" = true;
                "iconScale" = 0.8;
                "id" = "Workspace";
                "labelMode" = "none";
                "occupiedColor" = "none";
                "pillSize" = 0.6;
                "showApplications" = false;
                "showApplicationsHover" = false;
                "showBadge" = true;
                "showLabelsOnlyWhenOccupied" = false;
                "unfocusedIconsOpacity" = 1;
              }
              {
                "compactMode" = false;
                "hideMode" = "hidden";
                "hideWhenIdle" = false;
                "id" = "MediaMini";
                "maxWidth" = 1000;
                "panelShowAlbumArt" = true;
                "scrollingMode" = "hover";
                "showAlbumArt" = false;
                "showArtistFirst" = false;
                "showProgressRing" = true;
                "showVisualizer" = false;
                "textColor" = "none";
                "useFixedWidth" = false;
                "visualizerType" = "mirrored";
              }
            ];
            "center" = [
              {
                "clockColor" = "none";
                "customFont" = "";
                "formatHorizontal" = "HH:mm ddd MMM d";
                "formatVertical" = "HH mm - dd MM";
                "id" = "Clock";
                "tooltipFormat" = "HH=mm ddd, MMM dd";
                "useCustomFont" = false;
              }
            ];
            "right" = [
              {
                "displayMode" = "alwaysShow";
                "iconColor" = "none";
                "id" = "Volume";
                "middleClickCommand" = "pwvucontrol || pavucontrol";
                "textColor" = "none";
              }
              {
                "applyToAllMonitors" = false;
                "displayMode" = "alwaysShow";
                "iconColor" = "none";
                "id" = "Brightness";
                "textColor" = "none";
              }
              {
                "displayMode" = "alwaysShow";
                "iconColor" = "none";
                "id" = "Network";
                "textColor" = "none";
              }
              {
                "displayMode" = "onhover";
                "iconColor" = "none";
                "id" = "Bluetooth";
                "textColor" = "none";
              }
              {
                "deviceNativePath" = "__default__";
                "displayMode" = "icon-always";
                "hideIfIdle" = false;
                "hideIfNotDetected" = true;
                "id" = "Battery";
                "showNoctaliaPerformance" = false;
                "showPowerProfiles" = false;
              }
              {
                "hideWhenZero" = true;
                "hideWhenZeroUnread" = false;
                "iconColor" = "none";
                "id" = "NotificationHistory";
                "showUnreadBadge" = true;
                "unreadBadgeColor" = "primary";
              }
              {
                "blacklist" = [];
                "chevronColor" = "none";
                "colorizeIcons" = false;
                "drawerEnabled" = true;
                "hidePassive" = false;
                "id" = "Tray";
                "pinned" = [];
              }
              {
                "id" = "ControlCenter";
                "colorizeDistroLogo" = false;
                "colorizeSystemIcon" = "none";
                "colorizeSystemText" = "none";
                "customIconPath" = "";
                "enableColorization" = true;
                "icon" = "noctalia";
                "useDistroLogo" = true;
              }
            ];
          };
        };
        ui = {
          fontDefault = "DejaVuSansM Nerd Font";
          fontFixed = "DejaVuSansM Nerd Font Mono";
        };
        location = {
          name = "Leeds";
          autoLocate = false;
        };
        wallpaper = {
          enabled = false;
        };
        colourSchemes = {
          predefinedScheme = "Catppuccin";
        };
        nightLight = {
          enabled = true;
        };
        idle = {
          enabled = true;
        };
      };
      colors = {
        "mError" = "#f38ba8";
        "mHover" = "#94e2d5";
        "mOnError" = "#11111b";
        "mOnHover" = "#11111b";
        "mOnPrimary" = "#11111b";
        "mOnSecondary" = "#11111b";
        "mOnSurface" = "#cdd6f4";
        "mOnSurfaceVariant" = "#a3b4eb";
        "mOnTertiary" = "#11111b";
        "mOutline" = "#4c4f69";
        "mPrimary" = "#a6e3a1";
        "mSecondary" = "#cba6f7";
        "mShadow" = "#11111b";
        "mSurface" = "#1e1e2e";
        "mSurfaceVariant" = "#313244";
        "mTertiary" = "#94e2d5";
      };
    };
  };
}
