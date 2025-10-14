{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  inherit (config.catppuccin) sources;
  cfg = config.catppuccin;
  palette = (lib.importJSON "${sources.palette}/palette.json").${cfg.flavor}.colors;
  myfont = "DejaVuSansM Nerd Font Mono";
in {
  nixpkgs.overlays = [inputs.niri.overlays.niri];

  home.packages = with pkgs; [
    hyprcursor

    (writeShellApplication {
      name = "exit-session";
      text = ''
        niri msg action quit --skip-confirmation
      '';
    })

    (writeShellApplication {
      name = "pickcolour";
      runtimeInputs = [grim slurp imagemagick];
      text = ''
        grim -g "$(slurp -p)" -t ppm - | magick - -format '%[hex:p{0,0}]' info:- | wl-copy
      '';
    })

    (writeShellApplication {
      name = "timewarrior-bar";
      runtimeInputs = [timewarrior];
      text = ''
        out=$(timew)

        task=$( echo "$out" | grep "Tracking" | awk -F 'Tracking ' '{ print $2 }')
        time=$( echo "$out" | grep "Total" | awk '{ print $2 }')

        printf "%s %s" "$task" "$time"

        [[ "$time" = "0:25:00" ]] && notify-send "You've been working on $task for 25 minutes." "Time for a break."

        if [[ "$task" = "break short" && "$time" = "0:05:00" ]]  || [[ "$task" = "break long" && "$time" = "0:15:00" ]]; then
            notify-send "Play time is over." "Get back to work."
            # paplay ~/.scripts/bell-counter.wav
        fi
      '';
    })
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
      layout = {
        gaps = 2;
        background-color = "${palette.mantle.hex}";
        preset-column-widths = [
        {proportion = 0.495;}
        {proportion = 0.99;}
          # {proportion = 1. / 3.;}
          # {proportion = 1. / 2.;}
          # {proportion = 2. / 3.;}
        ];
        default-column-width.proportion = 0.495;
        focus-ring = {
          enable = false;
          width = 2;
          active.color = "${palette.green.hex}";
          inactive.color = "${palette.base.hex}";
        };
        border = {
          enable = true;
          width = 2;
          active.color = "${palette.green.hex}";
          inactive.color = "${palette.base.hex}";
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
      spawn-at-startup = [
      ];
      hotkey-overlay.skip-at-startup = true;
      binds = with config.lib.niri.actions; {
        "Mod+Return".action.spawn = "footclient";

        "Mod+Q" = {
          action = close-window;
          repeat = false;
        };
        "Mod+W".action.spawn = "firefox";
        "Mod+Shift+W".action.spawn = "firefox --private-window";
        "Mod+E".action.spawn = "wlogout";

        "Mod+T".action = toggle-column-tabbed-display;

        "Mod+U".action.spawn-sh = "$TERMINAL -e qalc";
        "Mod+Shift+U".action = move-workspace-down;
        "Mod+I".action.spawn-sh = "$TERMINAL -e btm";
        "Mod+Shift+I".action = move-workspace-up;
        "Mod+O" = {
          action = toggle-overview;
          repeat = false;
        };
        "Mod+P".action.spawn = "pickcolour";
        "Mod+Shift+P".action = power-off-monitors;
        "Mod+A".action.spawn = "pwvucontrol";
        "Mod+Shift+S".action.spawn = "loginctl lock-session";
        "Mod+D".action.spawn-sh = "fuzzel";
        "Mod+Shift+D".action.spawn = "pass-menu";
        # "Mod+F".action = maximize-column;
        "Mod+F".action = switch-preset-column-width;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+Ctrl+F".action = expand-column-to-available-width;

        "Mod+C".action = center-column;
        "Mod+Shift+C".action = center-visible-columns;

        "Mod+Comma".action = consume-or-expel-window-left;
        "Mod+Period".action = consume-or-expel-window-right;

        "Mod+F2".action.spawn = "networkmanager_dmenu";
        "Mod+F3".action.spawn = "clipmenu";

        "XF86AudioRaiseVolume" = {
          action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
          allow-when-locked = true;
        };
        "XF86AudioLowerVolume" = {
          action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
          allow-when-locked = true;
        };
        "XF86AudioMute" = {
          action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          allow-when-locked = true;
        };
        "XF86AudioMicMute" = {
          action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
          allow-when-locked = true;
        };
        "XF86MonBrightnessUp" = {
          action.spawn = ["brightnessctl" "--class=backlight" "set" "+10%"];
          allow-when-locked = true;
        };
        "XF86MonBrightnessDown" = {
          action.spawn = ["brightnessctl" "--class=backlight" "set" "10%-"];
          allow-when-locked = true;
        };

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

        "Print".action.spawn-sh = "grim ~/pics/scrns/$(date -u +%Y-%m-%d-%H-%M-%S-%N).png";
        "Shift+Print".action.spawn = "grimwarp";
      };
    };
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "graphical-session.target";
    settings = {
      mainBar = {
        layer = "top";
        # output = ["eDP-1" "DP-2"];
        position = "left";
        modules-left = ["clock" "custom/sep" "clock#date"];
        modules-center = ["niri/workspaces"];
        modules-right = ["network" "custom/sep" "wireplumber" "custom/sep" "backlight" "custom/sep" "battery"];
        "niri/workspaces" = {
          rotate = 90;
          "format" = "{icon}";
          "format-icons" = {
            "active" = " \n ";
            "urgent" = "";
            "default" = "";
          };
        };
        "niri/window" = {
          format = "";
          icon = true;
        };
        "custom/sep" = {
          "format" = "";
          tooltip = false;
        };
        tray = {
          icon-size = 21;
          spacing = 1;
        };
        clock = {
          format = "{:%H\n%M}";
          tooltip-format = "{:%H:%M (%Z)}";
        };
        "clock#date" = {
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          format = "{:%d\n%m}";
          calendar = {
            "mode" = "year";
            "mode-mon-col" = 3;
            "weeks-pos" = "right";
            "on-scroll" = 1;
            "format" = {
              "months" = "<span color='${palette.rosewater.hex}'><b>{}</b></span>";
              "days" = "<span color='${palette.pink.hex}'><b>{}</b></span>";
              "weeks" = "<span color='${palette.teal.hex}'><b>W{}</b></span>";
              "weekdays" = "<span color='${palette.yellow.hex}'><b>{}</b></span>";
              "today" = "<span color='${palette.sky.hex}'><b><u>{}</u></b></span>";
            };
          };
        };
        backlight = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          format-icons = ["󰛩" "󱩎" "󱩏" "󱩐" "󱩑" "󱩒" "󱩓" "󱩔" "󱩕" "󱩖" "󰛨"];
          rotate = 90;
        };
        battery = {
          states = {
            warning = 20;
            critical = 10;
          };
          format = "{icon} {capacity}%";
          format-icons = {
            default = ["󰂎" "󱊡" "󱊢" "󱊣"];
            charging = ["󰢟" "󱊤" "󱊥" "󱊦"];
          };
          rotate = 90;
        };
        wireplumber = {
          format = "{icon}  {volume}%";
          format-muted = " ";
          tooltip-format = "{icon}  {volume}% ({node_name})";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "pwvucontrol";
          format-icons = ["" "" ""];
          rotate = 90;
        };
        network = {
          interface = "w*";
          format = "{icon}  {essid}";
          format-disconnected = "󰤭 ";
          tooltip-format = "{icon}  {essid} ({signalStrength}%)";
          tooltip-format-disconnected = "󰤭 ";
          max-length = 50;
          on-click = "networkmanager_dmenu";
          format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          rotate = 90;
        };
        "custom/task" = {
          exec = "~/.nix-profile/bin/timewarrior-bar";
          restart-interval = 1;
        };
      };
    };
    style = ''
      * {
        font-family: DejaVuSansM Nerd Font;
        font-size: 14px;
        padding: 0;
        margin: 0;
      }

      #waybar {
        background: @mantle;
        color: @text;
      }

      .modules-left,
      .modules-right,
      .modules-center {
        padding: 0.5rem;
      }

      .modules-right {
        padding-bottom: 1rem;
      }

      tooltip {
        background-color: @base;
        border: 1px solid @mantle;
      }
      tooltip label {
        color: @text;
      }

      #window {
        background-color: @red;
        /* padding: 4px 0; */
      }

      #workspaces {
        font-size: 20px;
        font-family: DejaVuSansM Nerd Font Mono;
      }

      #workspaces button {
        font-family: DejaVuSansM Nerd Font Mono;
        color: transparent;
        background-color: @surface1;
        border-radius: 1rem;
        border: none;
        border-color: transparent;
        box-shadow: none;
        margin: 0.25rem 0;
        padding: 0;
      }

      #workspaces button.active {
        font-weight: bold;
        background-color: @green;
      }

      #workspaces button:hover {
        background-color: @lavender;
      }

      #workspaces button.focused {
        background-color: @green;
      }

      #workspaces button.focused:hover {
        background-color: @lavender;
      }

      #workspaces button.urgent {
        font-weight: bold;
        background-color: @red;
      }

      #workspaces button.urgent:hover {
        background-color: @lavender;
      }

      #workspaces button.empty:not(.focused) {
        background-color: @surface0;
      }

      #workspaces button.empty:not(.focused):hover {
        background-color: @lavender;
      }

      #custom-sep {
        font-family: DejaVuSansM Nerd Font Mono;
        color: @surface1;
        margin: 4px 0;
      }

      #clock {
        color: @blue;
      }

      #network {
        color: @sky;
      }

      #wireplumber {
        color: @mauve;
      }

      #backlight {
        color: @yellow;
      }

      #battery {
        color: @pink;
      }

      #battery.charging {
        color: @green;
      }

      #battery.warning:not(.charging) {
        color: @peach;
      }

      #battery.critical:not(.charging) {
        color: @red;
      }

    '';
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        grace = 10;
        hide_cursor = true;
      };

      background = [
        {
          color = "$base";
        }
      ];

      input-field = [
        {
          position = "0, 0";
          font_family = "${myfont} 10";
          dots_center = true;
          fade_on_empty = false;
          font_color = "$text";
          inner_color = "rgba(0,0,0,0)";
          outer_color = "rgba(0,0,0,0)";
          check_color = "rgba(0,0,0,0)";
          fail_color = "rgba(0,0,0,0)";
          placeholder_text = "󰌾";
          fail_text = "󰣮";
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
            criteria = "HDMI-A-2";
          }
        ];
      }
    ];
  };

  programs.swaylock = {
    enable = false;
  };

  services.swayidle = {
    enable = true;
    systemdTarget = "graphical-session.target";
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        event = "lock";
        command = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
        resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl -r";
      }
      {
        timeout = 300;
        command = "${pkgs.brightnessctl}/bin/brightnessctl -sd tpacpi::kbd_backlight set 0";
        resumeCommand = "${pkgs.brightnessctl}/bin/brightnessctl -rd tpacpi::kbd_backlight";
      }
      {
        timeout = 600;
        command = "${pkgs.systemd}/bin/loginctl lock-session";
      }
      {
        timeout = 630;
        command = "${pkgs.niri}/bin/niri msg action power-off-monitor";
      }
      {
        timeout = 1800;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };

  services.hypridle = {
    enable = false;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
      };

      listener = [
        {
          timeout = 300;
          on-timeout = "brightnessctl -s set 10";
          on-resume = "brightnessctl -r";
        }

        {
          timeout = 300;
          on-timeout = "brightnessctl -sd tpacpi::kbd_backlight set 0";
          on-resume = "brightnessctl -rd tpacpi::kbd_backlight";
        }

        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }

        {
          timeout = 630;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }

        # {
        # timeout = 1800;
        # on-timeout = "systemctl suspend";
        # }
      ];
    };
  };

  programs.wlogout = {
    enable = true;
  };
}
