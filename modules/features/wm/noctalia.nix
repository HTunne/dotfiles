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
    programs.noctalia = {
      enable = true;
      settings = {
        bar = {
          default = {
            concave_edge_corners = false;
            end = [
              "volume"
              "brightness"
              "network"
              "bluetooth"
              "battery"
              "notifications"
              "control-center"
            ];
            margin_ends = 0;
            start = [
              "workspaces"
              "media"
            ];
          };
        };
        location = {address = "Leeds";};
        lockscreen.tint_intensity = 1.0;
        lockscreen_widgets = {
          enabled = true;
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };
          schema_version = 2;
          widget = {
            "lockscreen-login-box@HDMI-A-2" = {
              box_height = 70;
              box_width = 400;
              cx = 1280;
              cy = 1321;
              output = "HDMI-A-2";
              rotation = 0;
              settings = {
                background_color = "surface_variant";
                background_opacity = 0.88;
                background_radius = 12;
                center_password_text = false;
                input_opacity = 1;
                input_radius = 6;
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_password_hint = true;
              };
              type = "login_box";
            };
            "lockscreen-login-box@eDP-1" = {
              box_height = 70;
              box_width = 400;
              cx = 960;
              cy = 961;
              output = "eDP-1";
              rotation = 0;
              settings = {
                background_color = "surface_variant";
                background_opacity = 0;
                background_radius = 12;
                center_password_text = false;
                input_opacity = 1;
                input_radius = 6;
                show_caps_lock = true;
                show_keyboard_layout = true;
                show_login_button = true;
                show_password_hint = true;
              };
              type = "login_box";
            };
            lockscreen-widget-0000000000000001 = {
              box_height = 0;
              box_width = 0;
              cx = 1743;
              cy = 93;
              output = "eDP-1";
              rotation = 0;
              settings = {
                background_opacity = 0;
                clock_style = "digital";
                color = "on_surface";
                shadow = true;
              };
              type = "clock";
            };
            lockscreen-widget-0000000000000002 = {
              box_height = 0;
              box_width = 0;
              cx = 176;
              cy = 90;
              output = "eDP-1";
              rotation = 0;
              type = "weather";
            };
            lockscreen-widget-0000000000000003 = {
              box_height = 400;
              box_width = 1920;
              cx = 958;
              cy = 542;
              output = "eDP-1";
              rotation = 0;
              settings = {
                bands = 32;
                color_1 = "primary";
                show_when_idle = true;
              };
              type = "audio_visualizer";
            };
          };
          widget_order = [
            "lockscreen-login-box@HDMI-A-2"
            "lockscreen-login-box@eDP-1"
            "lockscreen-widget-0000000000000001"
            "lockscreen-widget-0000000000000002"
            "lockscreen-widget-0000000000000003"
          ];
        };
        shell = {
          font_family = "DroidSansM Nerd Font";
          niri_overview_type_to_launch_enabled = true;
          session = {
            actions = [
              {
                action = "lock";
                countdown_seconds = 0;
                enabled = true;
                shortcut = "l";
                variant = "default";
              }
              {
                action = "logout";
                countdown_seconds = 0;
                enabled = true;
                shortcut = "e";
                variant = "default";
              }
              {
                action = "lock_and_suspend";
                countdown_seconds = 0;
                enabled = true;
                shortcut = "s";
                variant = "default";
              }
              {
                action = "reboot";
                countdown_seconds = 0;
                enabled = true;
                shortcut = "r";
                variant = "default";
              }
              {
                action = "shutdown";
                countdown_seconds = 0;
                enabled = true;
                shortcut = "s";
                variant = "destructive";
              }
            ];
          };
        };
        theme = {builtin = "Catppuccin";};
        wallpaper = {
          enabled = false;
        };
        widget = {
          clock = {format = "{:%Y-%m-%d %H:%M}";};
          control-center = {glyph = "circle-dashed";};
          media = {hide_when_no_media = true;};
        };
      };
    };
  };
}
