{
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
  home.packages = with pkgs; [
    hyprcursor

    (writeShellApplication {
      name = "monitormenu";
      runtimeInputs = [bemenu];
      text = ''
        monitors=$(hyprctl monitors all | awk '{if ($1 == "Monitor") print $2}')
        choice=$(echo "$monitors" | sed 's/ /\n/' | bemenu)
        echo "$choice"
        for monitor in $monitors;
        do

          if [ "$monitor" = "$choice" ]; then
            echo "enable" "$monitor"
            hyprctl keyword monitor "$monitor",preferred,auto,1
          else
            echo "disable" "$monitor"
            hyprctl keyword monitor "$monitor",disable
          fi
        done
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

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      pkgs.hyprlandPlugins.hy3
    ];
    settings = {
      "$mod" = "SUPER";
      bind =
        [
          "$mod, Q, killactive"
          "$mod, W, exec, firefox"
          "$mod SHIFT, W, exec, firefox --private-window"
          "$mod, E, exec, powermenu"
          "$mod, E SHIFT, exec, powermenu"
          "$mod, R, exec, firefox"
          "$mod, T, exec, firefox"
          "$mod, Y, exec, firefox"
          "$mod SHIFT, Y, resizeactive, -10 0"
          "$mod, U, togglespecialworkspace, calc"
          "$mod SHIFT, U, resizeactive, 0 -10"
          "$mod, I, togglespecialworkspace, monitor"
          "$mod SHIFT, I, resizeactive, 0 10"
          "$mod, O, exec, firefox"
          "$mod SHIFT, O, resizeactive, 10 0"
          "$mod, P, exec, pickcolour"
          "$mod, A, togglespecialworkspace, audio"
          "$mod SHIFT, A, togglespecialworkspace, audio"
          "$mod, S, exec, firefox"
          "$mod, D, exec, bemenu-run -p run"
          "$mod SHIFT, D, exec, pass-menu"
          "$mod, F, fullscreen"
          "$mod, G, hy3:makegroup, tab"
          "$mod, H, hy3:movefocus, l"
          "$mod SHIFT, H, hy3:movewindow, l"
          "$mod, J, hy3:movefocus, d"
          "$mod SHIFT, J, hy3:movewindow, d"
          "$mod, K, hy3:movefocus, u"
          "$mod SHIFT, K, hy3:movewindow, u"
          "$mod, L, hy3:movefocus, r"
          "$mod SHIFT, L, hy3:movewindow, r"
          "$mod, X, exec, timew start short break"
          "$mod SHIFT, X, exec, timew start long break"
          "$mod, C, exec, timew continue @2"
          "$mod SHIFT, C, exec, timew continue"
          "$mod, F1, exec, killall .waybar-wrapped; waybar &"
          "$mod, F2, exec, networkmanager_dmenu"
          "$mod, F3, exec, monitormenu"
          "$mod, LEFT, hy3:movefocus, l"
          "$mod SHIFT, LEFT, hy3:movewindow, l"
          "$mod, DOWN, hy3:movefocus, d"
          "$mod SHIFT, DOWN, hy3:movewindow, d"
          "$mod, UP, hy3:movefocus, u"
          "$mod SHIFT, UP, hy3:movewindow, u"
          "$mod, RIGHT, hy3:movefocus, r"
          "$mod SHIFT, RIGHT, hy3:movewindow, r"
          "$mod, RETURN, exec, foot"
          "$mod SHIFT, RETURN, togglespecialworkspace, term"
          "$mod, SPACE, togglefloating,"
          ", Print, exec, grim ~/pics/scrns/$(date -u +%Y-%m-%d-%H-%M-%S-%N).png"
          "SHIFT, Print, exec, grimwrap"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (builtins.genList (
              x: let
                ws = let
                  c = (x + 1) / 10;
                in
                  builtins.toString (x + 1 - (c * 10));
              in [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
              ]
            )
            10)
        );
      workspace = [
        "special:term, on-created-empty:[float;size 80% 80%;opacity 0.9] foot"
        "special:monitor, on-created-empty:[float;size 80% 80%;opacity 0.9] foot -e btm"
        "special:calc, on-created-empty:[float;size 80% 80%;opacity 0.9] foot -e qalc"
        "special:audio, on-created-empty:[float;size 80% 80%;opacity 0.9] pwvucontrol"
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        "SHIFT,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 100%"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        "SHIFT,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        "SHIFT,XF86MonBrightnessUp, exec, brightnessctl s 100%"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
        "SHIFT,XF86MonBrightnessDown, exec, brightnessctl s 0%"
      ];
      general = {
        layout = "hy3";
        gaps_in = 0;
        gaps_out = 0;
        border_size = 1;
        resize_on_border = true;
        "col.active_border" = "$accent";
        "col.inactive_border" = "$base";
      };
      animations.enabled = false;
      # monitor = [
      # ",preffered,auto,1,mirror,DP-2,bitdepth,8"
      # ];
      misc = {
        force_default_wallpaper = 1;
        disable_hyprland_logo = true;
      };
      input = {
        kb_layout = "gb";
        kb_options = "caps:escape";
      };
      exec-once = [
        # "waybar & "
        # "swaybg -c $mantleAlpha &"
      ];
      "debug:disable_logs" = false;
      plugin = {
        hy3 = {
          tabs = {
            height = 4;
            padding = 0;
            radius = 0;
            border_width = 2;
            render_text = false;
            "col.active.border" = "$accent";
            "col.focused.border" = "$surface0";
            "col.inactive.border" = "$base";
            "col.urgent.border" = "$red";
            "col.locked.border" = "$yellow";
          };
        };
      };
    };
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        # output = ["eDP-1" "DP-2"];
        position = "top";
        modules-left = ["hyprland/workspaces"];
        modules-center = ["hyprland/window"];
        modules-right = ["custom/task" "network" "wireplumber" "backlight" "battery" "clock"];
        "hyprland/workspaces" = {
          format = "{icon}";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        tray = {
          icon-size = 21;
          spacing = 1;
        };
        clock = {
          timezone = "Europe/London";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = " {:%H:%M   %Y-%m-%d}";
        };
        backlight = {
          device = "intel_backlight";
          format = "{icon} {percent}%";
          format-icons = ["" "" "" "" "" "" "" "" ""];
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}% ({time})";
          format-icons = {
            default = ["󰂎" "󱊡" "󱊢" "󱊣"];
            charging = ["󰢟" "󱊤" "󱊥" "󱊦"];
          };
        };
        wireplumber = {
          format = "{icon}  {volume}%";
          format-muted = "  MUTE";
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-click-right = "pwvucontrol";
          format-icons = ["" "" ""];
        };
        network = {
          interface = "wlp0s20f3";
          format = "{ifname}";
          format-wifi = "  {essid} ({signalStrength}%)";
          format-ethernet = "󰊗  {ipaddr}/{cidr}";
          format-disconnected = "";
          tooltip-format = "󰊗  {ifname} via {gwaddr}";
          tooltip-format-wifi = "  {essid} ({signalStrength}%)";
          tooltip-format-ethernet = "  {ifname}";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
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
        min-height: 0;
      }

      #waybar {
        background: transparent;
        color: @text;
      }

      #workspaces {
        /* border-radius: 1rem; */
        /* margin: 5px; */
        /* background-color: @surface0; */
        /* margin-left: 5px; */
      }

      #workspaces button {
        color: @overlay1;
        padding: 0.2rem;
      }

      #workspaces button.active {
        font-weight: bold;
        color: @green;
        border-radius: 0px;
      }

      #workspaces button:hover {
        color: @teal;
        background: transparent;
        border-radius: 0px;
        border-color: transparent;
        box-shadow: none;
      }

      #workspaces button.focused {
        background-color: transparent;
        box-shadow: none;
      }

      #workspaces button.urgent {
        font-weight: bold;
        color: @red;
        background-color: transparent;
      }

      #tray,
      #network,
      #backlight,
      #clock,
      #battery,
      #wireplumber {
        margin: 0 0.5rem;
        padding: 0.2rem 0.5rem;
      }

      #network {
        color: @pink;
        border-color: @pink;
      }

      #wireplumber {
        color: @mauve;
        border-color: @mauve;
      }

      #backlight {
        color: @yellow;
        border-color: @yellow;
      }

      #battery {
        color: @peach;
        border-color: @peach;
      }

      #battery.charging {
        color: @green;
        border-color: @green;
      }

      #battery.warning:not(.charging) {
        color: @red;
        border-color: @red;
      }

      #clock {
        color: @blue;
        border-color: @blue;
      }
    '';
  };

  systemd.user.services.swaybg = {
    Unit = {
      Description = "Start waybar system bar.";
      BindsTo = "hyprland-session.target";
    };
    Install = {
      WantedBy = ["hyprland-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -c ${palette.base.hex}";
      Restart = "on-failure";
      RestartSec = "30";
    };
  };

  systemd.user.services.waybar = {
    Unit = {
      Description = "Start waybar system bar.";
      BindsTo = "hyprland-session.target";
    };
    Install = {
      WantedBy = ["hyprland-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar";
      Restart = "on-failure";
      RestartSec = "30";
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 10;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          color = "$base";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          position = "0, 0";
          monitor = "";
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
          fail_timeout = 0;
          fail_transition = 0;
        }
      ];
    };
  };

  services.kanshi = {
    enable = true;
    systemdTarget = "hyprland-session.target";
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

  services.hypridle = {
    enable = true;
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
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
          on-resume = "brightnessctl -rd rgb:kbd_backlight";
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
}
