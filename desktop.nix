{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.niri = {
    enable = true;
    settings = {
      spawn-at-startup = [
        {command = ["noctalia-shell"];}
      ];

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
          accel-speed = 0.2;
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
        shadow = {
          enable = true;
          softness = 30;
          spread = 5;
          offset = {
            x = 1;
            y = 5;
          };
        };
      };

      outputs."eDP-1" = {
        enable = true;
        scale = 0.98;
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
        "XF86AudioRaiseVolume".action.spawn = noctalia "volume increase";
        "XF86AudioLowerVolume".action.spawn = noctalia "volume decrease";
        "XF86AudioMute".action.spawn = noctalia "volume muteOutput";
        "XF86AudioMicMute".action.spawn = noctalia "volume muteInput";

        "Mod+T".action = spawn "kitty";
        "Mod+B".action = spawn "firefox";
        "Mod+A".action.spawn = noctalia "launcher toggle";

        "Mod+Q".action = close-window;
        "Mod+Shift+Q".action = quit;

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
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;

        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";
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
      dock.enabled = false;

      location = {
        name = "Portland, OR";
        useFahrenheit = true;
        use12hourFormat = true;
      };

      bar.widgets.right = [
        {id = "Tray";}
        {id = "NotificationHistory";}
        {id = "Battery";}
        {id = "Volume";}
        {id = "Brightness";}
        {
          id = "Clock";
          formatHorizontal = "h:mm ap ddd, MMM dd";
        }
      ];

      ui = {
        fontDefualt = config.stylix.fonts.sansSerif.name;
        fontFixed = config.stylix.fonts.monospace.name;
      };

      appLauncher.terminalCommand = "kitty";

      wallpaper = {
        enabled = true;
        overviewEnabled = true;
        defaultWallpaper = ./backgrounds/Mountains.png;
      };
    };

    colors = with config.lib.stylix.colors; {
      mError = "#${base08}";
      mOnError = "#${base00}";
      mOnPrimary = "#${base00}";
      mOnSecondary = "#${base00}";
      mOnSurface = "#${base04}";
      mOnSurfaceVariant = "#${base04}";
      mOnTertiary = "#${base00}";
      mOutline = "#${base02}";
      mPrimary = "#${base0B}";
      mSecondary = "#${base0A}";
      mShadow = "#${base00}";
      mSurface = "#${base00}";
      mSurfaceVariant = "#${base01}";
      mTertiary = "#${base0D}";
    };
  };
}
