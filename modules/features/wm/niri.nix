{
  inputs,
  self,
  ...
}: {
  flake.nixosModules.niri = {
    programs.niri = {
      enable = true;
    };
  };

  flake.homeModules.niri = {
    config,
    pkgs,
    lib,
    ...
  }: let
    inherit (config.catppuccin) sources;
    cfg = config.catppuccin;
    palette = (lib.importJSON "${sources.palette}/palette.json").${cfg.flavor}.colors;
    focus-or-spawn = pkgs.writeShellApplication {
      name = "focus-or-spawn";
      runtimeInputs = [pkgs.niri];
      text = ''
        app_id="$1"
        shift

        win_id=$(niri msg --json windows \
          | jq -r --arg app "$app_id" '.[] | select(.app_id==$app) | .id' \
          | head -n1)

        if [ -n "$win_id" ]; then
            niri msg action focus-window --id "$win_id"
        else
            exec "$@"
        fi
      '';
    };
  in {
    imports = [
      inputs.niri.homeModules.niri
    ];

    options.wm.niri.chat-app.pkg = lib.mkOption {
      type = lib.types.str;
      default = "discord";
    };
    options.wm.niri.chat-app.app_id = lib.mkOption {
      type = lib.types.str;
      default = "discord";
    };

    config = {
      nixpkgs.overlays = [
        inputs.niri.overlays.niri
        inputs.noctalia.overlays.default
      ];

      home.sessionVariables = {
        QT_QPA_PLATFORM = "wayland";
        # QT_QPA_PLATFORMTHEME = "qt5ct";
        MOZ_ENABLE_WAYLAND = 1;
      };

      programs.niri = {
        enable = true;
        package = pkgs.niri-unstable;
        settings = {
          spawn-at-startup = [
            {
              command = [(lib.getExe pkgs.noctalia-shell)];
            }
            {
              command = ["systemctl" "restart" "--user" "kanshi" "foot" "walker"];
            }
          ];
          xwayland-satellite = {
            enable = true;
            path = lib.getExe pkgs.xwayland-satellite-unstable;
          };
          input = {
            keyboard = {
              xkb = {
                layout = "gb";
                options = "caps:escape";
              };
            };
          };
          prefer-no-csd = true;
          screenshot-path = "~/pics/scrns/%Y-%m-%d_%H-%M-%S.png";
          layout = {
            gaps = 5;
            background-color = "${palette.mantle.hex}";
            # struts.left = 5;
            # struts.right = 5;
            # struts.top = 2;
            preset-column-widths = [
              {proportion = 0.5;}
              {proportion = 1.;}
            ];
            default-column-width.proportion = 0.5;
            focus-ring = {
              enable = false;
            };
            border = {
              enable = true;
              width = 2;
              active.color = "${palette.green.hex}";
              inactive.color = "${palette.surface0.hex}";
            };
            tab-indicator = {
              hide-when-single-tab = true;
              position = "right";
              width = 2;
              gap = -2;
              active.color = "${palette.green.hex}";
              # inactive.color = "${palette.green.hex}";
              length.total-proportion = 1.0;
            };
          };
          overview.backdrop-color = "${palette.crust.hex}";
          hotkey-overlay.skip-at-startup = true;
          binds = with config.lib.niri.actions; {
            "Mod+Return".action.spawn = "footclient";

            "Mod+Q" = {
              action = close-window;
              repeat = false;
            };
            "Mod+W".action.spawn = lib.getExe pkgs.firefox;
            "Mod+Shift+W".action.spawn = [(lib.getExe pkgs.firefox) "--private-window"];
            "Mod+E".action.spawn = [(lib.getExe pkgs.noctalia-shell) "ipc" "call" "sessionMenu" "toggle"];

            "Mod+T".action = toggle-column-tabbed-display;

            "Mod+U".action.spawn = [(lib.getExe pkgs.walker) "-m" "calc"];
            "Mod+Shift+U".action = move-workspace-down;
            "Mod+I".action.spawn-sh = "$TERMINAL -e btm";
            "Mod+Shift+I".action = move-workspace-up;
            "Mod+O" = {
              action = toggle-overview;
              repeat = false;
            };
            "Mod+P".action.spawn = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.pickcolour;
            "Mod+Shift+P".action = power-off-monitors;
            "Mod+A".action.spawn = lib.getExe pkgs.pwvucontrol;
            "Mod+Shift+S".action.spawn = "loginctl lock-session";
            "Mod+D".action.spawn = ["nc" "-U" "/run/user/1000/walker/walker.sock"];
            "Mod+Shift+D".action.spawn = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.pass-menu;
            # "Mod+F".action = maximize-column;
            "Mod+F".action = switch-preset-column-width;
            "Mod+Shift+F".action = fullscreen-window;
            "Mod+Ctrl+F".action = expand-column-to-available-width;

            "Mod+C".action = center-column;
            "Mod+Shift+C".action = center-visible-columns;

            "Mod+B".action.spawn = ["${focus-or-spawn}/bin/focus-or-spawn" config.wm.niri.chat-app.app_id config.wm.niri.chat-app.pkg];
            "Mod+Shift+B".action.spawn = ["${focus-or-spawn}/bin/focus-or-spawn" "thunderbird" "thunderbird"];

            "Mod+Comma".action = consume-or-expel-window-left;
            "Mod+Period".action = consume-or-expel-window-right;

            "Mod+F2".action.spawn = "networkmanager_dmenu";
            "Mod+F3".action.spawn = [(lib.getExe pkgs.walker) "-m" "clipboard"];

            "XF86AudioRaiseVolume" = {
              action.spawn = [(lib.getExe pkgs.noctalia-shell) "ipc" "call" "volume" "increase"];
              allow-when-locked = true;
            };
            "XF86AudioLowerVolume" = {
              action.spawn = [(lib.getExe pkgs.noctalia-shell) "ipc" "call" "volume" "decrease"];
              allow-when-locked = true;
            };
            "XF86AudioMute" = {
              action.spawn = [(lib.getExe pkgs.noctalia-shell) "ipc" "call" "volume" "muteOutput"];
              allow-when-locked = true;
            };
            "XF86AudioMicMute" = {
              action.spawn = [(lib.getExe pkgs.noctalia-shell) "ipc" "call" "volume" "muteInput"];
              allow-when-locked = true;
            };
            "XF86MonBrightnessUp" = {
              action.spawn = [(lib.getExe pkgs.noctalia-shell) "ipc" "call" "brightness" "increase"];
              allow-when-locked = true;
            };
            "XF86MonBrightnessDown" = {
              action.spawn = [(lib.getExe pkgs.noctalia-shell) "ipc" "call" "brightness" "decrease"];
              allow-when-locked = true;
            };
            # TODO: add media controls

            "Mod+H".action = focus-column-left;
            "Mod+J".action = focus-window-or-workspace-down;
            "Mod+K".action = focus-window-or-workspace-up;
            "Mod+L".action = focus-column-right;
            "Mod+Left".action = focus-column-left;
            "Mod+Down".action = focus-window-or-workspace-down;
            "Mod+Up".action = focus-window-or-workspace-up;
            "Mod+Right".action = focus-column-right;

            "Mod+Shift+H".action = move-column-left;
            "Mod+Shift+J".action = move-window-down-or-to-workspace-down;
            "Mod+Shift+K".action = move-window-up-or-to-workspace-up;
            "Mod+Shift+L".action = move-column-right;
            "Mod+Shift+Left".action = move-column-left;
            "Mod+Shift+Down".action = move-window-down-or-to-workspace-down;
            "Mod+Shift+Up".action = move-window-up-or-to-workspace-up;
            "Mod+Shift+Right".action = move-column-right;

            "Mod+Home".action = focus-column-first;
            "Mod+End".action = focus-column-last;
            "Mod+Shift+Home".action = move-column-to-first;
            "Mod+Shift+End".action = move-column-to-last;

            "Mod+Page_Down".action = focus-workspace-down;
            "Mod+Page_Up".action = focus-workspace-up;

            "Mod+Ctrl+H".action = focus-monitor-left;
            "Mod+Ctrl+J".action = focus-monitor-down;
            "Mod+Ctrl+K".action = focus-monitor-up;
            "Mod+Ctrl+L".action = focus-monitor-right;
            "Mod+Ctrl+Left".action = focus-monitor-left;
            "Mod+Ctrl+Down".action = focus-monitor-down;
            "Mod+Ctrl+Up".action = focus-monitor-up;
            "Mod+Ctrl+Right".action = focus-monitor-right;

            "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
            "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
            "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
            "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;
            "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
            "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
            "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
            "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;

            "Mod+WheelScrollDown" = {
              action = focus-workspace-down;
              cooldown-ms = 150;
            };
            "Mod+WheelScrollUp" = {
              action = focus-workspace-up;
              cooldown-ms = 150;
            };
            "Mod+Ctrl+WheelScrollDown" = {
              action = move-column-to-workspace-down;
              cooldown-ms = 150;
            };
            "Mod+Ctrl+WheelScrollUp" = {
              action = move-column-to-workspace-up;
              cooldown-ms = 150;
            };

            "Mod+WheelScrollRight".action = focus-column-right;
            "Mod+WheelScrollLeft".action = focus-column-left;
            "Mod+Ctrl+WheelScrollRight".action = move-column-right;
            "Mod+Ctrl+WheelScrollLeft".action = move-column-left;

            "Mod+Shift+WheelScrollDown".action = focus-column-right;
            "Mod+Shift+WheelScrollUp".action = focus-column-left;
            "Mod+Ctrl+Shift+WheelScrollDown".action = move-column-right;
            "Mod+Ctrl+Shift+WheelScrollUp".action = move-column-left;

            "Mod+1".action.focus-workspace = 1;
            "Mod+2".action.focus-workspace = 2;
            "Mod+3".action.focus-workspace = 3;
            "Mod+4".action.focus-workspace = 4;
            "Mod+5".action.focus-workspace = 5;
            "Mod+6".action.focus-workspace = 6;
            "Mod+7".action.focus-workspace = 7;
            "Mod+8".action.focus-workspace = 8;
            "Mod+9".action.focus-workspace = 9;
            "Mod+Shift+1".action.move-column-to-workspace = 1;
            "Mod+Shift+2".action.move-column-to-workspace = 2;
            "Mod+Shift+3".action.move-column-to-workspace = 3;
            "Mod+Shift+4".action.move-column-to-workspace = 4;
            "Mod+Shift+5".action.move-column-to-workspace = 5;
            "Mod+Shift+6".action.move-column-to-workspace = 6;
            "Mod+Shift+7".action.move-column-to-workspace = 7;
            "Mod+Shift+8".action.move-column-to-workspace = 8;
            "Mod+Shift+9".action.move-column-to-workspace = 9;

            "Mod+BracketLeft".action = consume-or-expel-window-left;
            "Mod+BracketRight".action = consume-or-expel-window-right;

            "Mod+Minus".action.set-column-width = "-10%";
            "Mod+Equal".action.set-column-width = "+10%";

            "Mod+Shift+Minus".action.set-window-height = "-10%";
            "Mod+Shift+Equal".action.set-window-height = "+10%";

            # Move the focused window between the floating and the tiling layout.
            "Mod+Space".action = toggle-window-floating;
            "Mod+Shift+Space".action = switch-focus-between-floating-and-tiling;

            # "Print".action.spawn-sh = "FILENAME=~/pics/scrns/$(date -u +%Y-%m-%d-%H-%M-%S-%N).png && grim $FILENAME && notify-send \"Screenshot captured\" $FILENAME";
            # "Shift+Print".action.spawn = "grimwarp";
            "Print".action.spawn = ["niri" "msg" "action" "screenshot"];
            "Shift+Print".action.spawn = ["niri" "msg" "action" "screenshot-screen"];
            "Ctrl+Print".action.spawn = ["niri" "msg" "action" "screenshot-window"];
            "Mod+Print".action.spawn-sh = "niri msg action screenshot && wl-paste | swappy -f -";
            "Mod+Shift+Print".action.spawn-sh = "niri msg action screenshot-screen && wl-paste | swappy -f -";
            "Mod+Ctrl+Print".action.spawn-sh = "niri msg action screenshot-window && wl-paste | swappy -f -";
          };
          window-rules = [
            {
              geometry-corner-radius = {
                bottom-left = 5.;
                bottom-right = 5.;
                top-left = 5.;
                top-right = 5.;
              };
              clip-to-geometry = true;
            }
          ];
        };
      };

      services.kanshi = {
        enable = true;
        systemdTarget = "graphical-session.target";
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
  };
}
