{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
    settings = {
      spawn-at-startup = [
        {command = ["noctalia-shell"];}
      ];

      hotkey-overlay.skip-at-startup = true;

      input = {
        keyboard.numlock = true;

        touchpad = {
          accel-speed = 0.5;
          accel-profile = "adaptive";
          dwt = true;
          dwtp = true;
          drag = true;
          drag-lock = true;
          natural-scroll = true;
          tap = true;
        };

        trackpoint = {
          accel-speed = 0.3;
          accel-profile = "flat";
        };

        warp-mouse-to-focus.enable = true;
        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "25%";
        };
      };

      prefer-no-csd = true;

      layout = {
        gaps = 8;
        center-focused-column = "never";
        preset-column-widths = [
          {proportion = 0.333333;}
          {proportion = 0.5;}
          {proportion = 0.666667;}
        ];
        default-column-width = {proportion = 0.5;};
        focus-ring = {
          enable = true;
          width = 2;
        };
        border.enable = false;
        shadow.enable = false;
      };

      gestures.hot-corners.enable = false;

      outputs = {
        "eDP-1" = {
          enable = true;
          scale = 0.98; # makes logical size 1952x1220
          position = {
            x = 0;
            y = 1220;
          };
        };

        "ASUSTek COMPUTER INC VG275 M8LMQS134325" = {
          enable = true;
          mode = {
            width = 1920;
            height = 1080;
            refresh = 74.977;
          };
          # put screen centered above laptop
          position = {
            x = 16;
            y = 0;
          };
        };
      };

      window-rules = [
        {
          matches = [
            {
              app-id = "firefox$";
              title = "^Picture-in-Picture$";
            }
          ];
          open-floating = true;
        }
        {
          geometry-corner-radius = {
            bottom-left = 10.0;
            top-left = 10.0;
            bottom-right = 10.0;
            top-right = 10.0;
          };
          clip-to-geometry = true;
        }
      ];

      layer-rules = [
        {
          matches = [{namespace = "^noctalia-overview";}];
          place-within-backdrop = true;
        }
      ];

      debug.honor-xdg-activation-with-invalid-serial = [];

      binds = with config.lib.niri.actions; let
        noctalia = cmd:
          [
            "noctalia-shell"
            "ipc"
            "call"
          ]
          ++ (lib.splitString " " cmd);
      in {
        "Mod+Shift+Slash".action = show-hotkey-overlay;

        "XF86AudioRaiseVolume" = {
          allow-when-locked = true;
          action.spawn = noctalia "volume increase";
        };
        "XF86AudioLowerVolume" = {
          allow-when-locked = true;
          action.spawn = noctalia "volume decrease";
        };
        "XF86AudioMute" = {
          allow-when-locked = true;
          action.spawn = noctalia "volume muteOutput";
        };
        "XF86AudioMicMute" = {
          allow-when-locked = true;
          action.spawn = noctalia "volume muteInput";
        };

        "XF86MonBrightnessUp" = {
          allow-when-locked = true;
          action.spawn = noctalia "brightness increase";
        };
        "XF86MonBrightnessDown" = {
          allow-when-locked = true;
          action.spawn = noctalia "brightness decrease";
        };

        "Mod+T" = {
          hotkey-overlay.title = "Open Terminal: Kitty";
          action = spawn "kitty";
        };
        "Mod+B" = {
          hotkey-overlay.title = "Open Web Browser: Firefox";
          action = spawn "firefox";
        };
        "Mod+A" = {
          hotkey-overlay.title = "Open App Launcher";
          action.spawn = noctalia "launcher toggle";
        };

        "Mod+Q" = {
          repeat = false;
          action = close-window;
        };
        "Mod+Shift+Q".action = quit;
        "Mod+Alt+L" = {
          hotkey-overlay.title = "Lock Screen";
          action.spawn = noctalia "lockScreen lock";
        };

        "Mod+U" = {
          repeat = false;
          action = toggle-overview;
        };

        "Mod+Escape" = {
          allow-inhibiting = false;
          action = toggle-keyboard-shortcuts-inhibit;
        };

        "Mod+H".action = focus-column-left;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        "Mod+L".action = focus-column-right;

        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+J".action = move-window-down;
        "Mod+Shift+K".action = move-window-up;
        "Mod+Shift+L".action = move-column-right;

        "Mod+Ctrl+H".action = focus-monitor-left;
        "Mod+Ctrl+J".action = focus-monitor-down;
        "Mod+Ctrl+K".action = focus-monitor-up;
        "Mod+Ctrl+L".action = focus-monitor-right;

        "Mod+Shift+Ctrl+H".action = move-window-to-monitor-left;
        "Mod+Shift+Ctrl+J".action = move-window-to-monitor-down;
        "Mod+Shift+Ctrl+K".action = move-window-to-monitor-up;
        "Mod+Shift+Ctrl+L".action = move-window-to-monitor-right;

        "Mod+O".action = focus-workspace-down;
        "Mod+I".action = focus-workspace-up;
        "Mod+Shift+O".action = move-column-to-workspace-down;
        "Mod+Shift+I".action = move-column-to-workspace-up;
        "Mod+Ctrl+O".action = move-workspace-down;
        "Mod+Ctrl+I".action = move-workspace-up;

        "Mod+BracketLeft".action = consume-or-expel-window-left;
        "Mod+BracketRight".action = consume-or-expel-window-right;
        "Mod+Comma".action = consume-window-into-column;
        "Mod+Period".action = expel-window-from-column;

        "Mod+R".action = switch-preset-column-width;
        "Mod+Ctrl+R".action = reset-window-height;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;
        "Mod+Ctrl+F".action = expand-column-to-available-width;

        "Mod+C".action = center-column;
        "Mod+Ctrl+C".action = center-visible-columns;

        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";

        "Mod+V".action = toggle-window-floating;
        "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

        "Mod+W".action = toggle-column-tabbed-display;
      };

      xwayland-satellite = {
        enable = true;
        path = lib.getExe pkgs.xwayland-satellite-unstable;
      };
    };
  };
  programs.noctalia-shell = {
    enable = true;
    settings = {
      general = {
        avatarImage = ./face.png;
        enableShadows = false;
        language = "en";
      };

      dock.enabled = false;

      location = {
        name = "Portland, OR";
        useFahrenheit = true;
        use12hourFormat = true;
      };

      controlCenter.position = "top_left";

      bar.widgets = {
        left = [
          {
            icon = "rocket";
            id = "CustomButton";
            leftClickExec = "noctalia-shell ipc call controlCenter toggle";
          }
          {id = "SystemMonitor";}
          {id = "MediaMini";}
        ];
        center = [{id = "Workspace";}];
        right = [
          {id = "Tray";}
          {id = "NotificationHistory";}
          {id = "Battery";}
          {id = "Volume";}
          {id = "Brightness";}
          {
            id = "Clock";
            formatHorizontal = "h:mm ap. ddd, MMM dd";
          }
        ];
      };

      ui = {
        fontDefualt = config.stylix.fonts.sansSerif.name;
        fontFixed = config.stylix.fonts.monospace.name;
      };

      appLauncher.terminalCommand = "kitty";

      wallpaper = {
        enabled = true;
        overviewEnabled = true;
        transitionType = "none";
      };

      brightness = {
        brightnessStep = 5;
        enforceMinimum = false;
        enableDdcSupport = true;
      };
    };
  };
}
