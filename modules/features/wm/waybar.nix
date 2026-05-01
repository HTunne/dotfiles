{inputs, ...}: {
  flake.homeModules.wm-base = {
    config,
    pkgs,
    lib,
    ...
  }: let
    inherit (config.catppuccin) sources;
    cfg = config.catppuccin;
    palette = (lib.importJSON "${sources.palette}/palette.json").${cfg.flavor}.colors;
    myfont = "DejaVuSansM Nerd Font Mono";
  in {
    programs.waybar = {
      enable = false;
      systemd.enable = true;
      systemd.targets = ["graphical-session.target"];
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
              "active" = "";
              "urgent" = "";
              "default" = "";
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
        }

        #workspaces button {
          color: @surface1;
          border-radius: 1rem;
          border: none;
          border-color: transparent;
          box-shadow: none;
          margin: 0;
          padding: 0;
        }

        #workspaces button.active {
          font-weight: bold;
          color: @green;
        }

        #workspaces button:hover {
          color: @lavender;
          background-color: transparent;
        }

        #workspaces button.focused {
          color: @green;
        }

        #workspaces button.focused:hover {
          color: @lavender;
          background-color: transparent;
        }

        #workspaces button.urgent {
          font-weight: bold;
          color: @red;
        }

        #workspaces button.urgent:hover {
          color: @lavender;
          background-color: transparent;
        }

        #workspaces button.empty:not(.focused) {
          color: @surface0;
        }

        #workspaces button.empty:not(.focused):hover {
          color: @lavender;
          background-color: transparent;
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
    systemd.user.services.waybar = {
      Unit.ConditionEnvironment = lib.mkForce "";
    };
  };
}
