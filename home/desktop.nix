{
  config,
  pkgs,
  lib,
  niriPkgs,
  ...
}: {
  wayland.windowManager.niri = {
    enable = true;
    package = niriPkgs.niri-unstable;

    settings = {
      spawn-at-startup = [
        {_args = ["ashell"];}
        {_args = [(lib.getExe pkgs.swaybg) "-i" config.stylix.image];}
      ];

      hotkey-overlay.skip-at-startup = [];

      input = {
        keyboard.numlock = [];

        touch.off = [];

        touchpad = {
          accel-speed = 0.5;
          accel-profile = "adaptive";
          dwt = [];
          dwtp = [];
          drag = true;
          drag-lock = [];
          natural-scroll = [];
          tap = [];
        };

        trackpoint = {
          accel-speed = 0.4;
          accel-profile = "flat";
        };

        warp-mouse-to-focus = [];
        focus-follows-mouse._props = {
          max-scroll-amount = "25%";
        };
      };

      prefer-no-csd = [];

      layout = {
        gaps = 8;
        center-focused-column = "never";
        preset-column-widths._children = [
          {proportion = 0.333333;}
          {proportion = 0.5;}
          {proportion = 0.666667;}
        ];
        default-column-width.proportion = 0.5;
        focus-ring.width = 2;
        border.off = [];
        shadow.off = [];
      };

      gestures.hot-corners.off = [];

      output = [
        {
          _args = ["eDP-1"];
          scale = 0.98; # makes logical size 1952x1220
          position._props = {
            x = 0;
            y = 1220;
          };
        }

        {
          _args = ["ASUSTek COMPUTER INC VG275 M8LMQS134325"];
          mode = "1920x1080@74.977";
          # put screen centered above laptop
          position._props = {
            x = 16;
            y = 0;
          };
        }
      ];

      window-rule = [
        {
          geometry-corner-radius = 10.0;
          clip-to-geometry = true;
        }
      ];

      binds = {
        "Mod+Shift+Slash".show-hotkey-overlay = [];

        "XF86AudioRaiseVolume" = {
          _props.allow-when-locked = true;
          spawn = ["wpctl" "set-volume" "-l" "1.0" "@DEFAULT_AUDIO_SINK@" "5%+"];
        };
        "XF86AudioLowerVolume" = {
          _props.allow-when-locked = true;
          spawn = ["wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"];
        };
        "XF86AudioMute" = {
          _props.allow-when-locked = true;
          spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"];
        };
        "XF86AudioMicMute" = {
          _props.allow-when-locked = true;
          spawn = ["wpctl" "set-mute" "@DEFAULT_AUDIO_SOURCE@" "toggle"];
        };

        "XF86MonBrightnessUp" = {
          _props.allow-when-locked = true;
          spawn = ["brillo" "-q" "-A" "5"];
        };
        "XF86MonBrightnessDown" = {
          _props.allow-when-locked = true;
          spawn = ["brillo" "-q" "-U" "5"];
        };

        "Mod+T" = {
          _props.hotkey-overlay-title = "Open Terminal: Kitty";
          spawn = "kitty";
        };
        "Mod+B" = {
          _props.hotkey-overlay-title = "Open Web Browser: Firefox";
          spawn = "firefox";
        };
        "Mod+E" = {
          _props.hotkey-overlay-title = "Open File Explorer";
          spawn = "cosmic-files";
        };

        "Mod+A" = {
          _props.hotkey-overlay-title = "Open App Launcher";
          spawn = "fuzzel";
        };

        "Mod+Q" = {
          _props.repeat = false;
          close-window = [];
        };
        "Mod+Shift+Q".quit = [];
        "Mod+Alt+L" = {
          _props.hotkey-overlay-title = "Lock Screen";
          spawn = "swaylock";
        };

        "Mod+U" = {
          _props.repeat = false;
          toggle-overview = [];
        };

        "Mod+Escape" = {
          _props.allow-inhibiting = false;
          toggle-keyboard-shortcuts-inhibit = [];
        };

        "Mod+H".focus-column-left = [];
        "Mod+J".focus-window-down = [];
        "Mod+K".focus-window-up = [];
        "Mod+L".focus-column-right = [];

        "Mod+Shift+H".move-column-left = [];
        "Mod+Shift+J".move-window-down = [];
        "Mod+Shift+K".move-window-up = [];
        "Mod+Shift+L".move-column-right = [];

        "Mod+Ctrl+H".focus-monitor-left = [];
        "Mod+Ctrl+J".focus-monitor-down = [];
        "Mod+Ctrl+K".focus-monitor-up = [];
        "Mod+Ctrl+L".focus-monitor-right = [];

        "Mod+Shift+Ctrl+H".move-window-to-monitor-left = [];
        "Mod+Shift+Ctrl+J".move-window-to-monitor-down = [];
        "Mod+Shift+Ctrl+K".move-window-to-monitor-up = [];
        "Mod+Shift+Ctrl+L".move-window-to-monitor-right = [];

        "Mod+O".focus-workspace-down = [];
        "Mod+I".focus-workspace-up = [];
        "Mod+Shift+O".move-column-to-workspace-down = [];
        "Mod+Shift+I".move-column-to-workspace-up = [];
        "Mod+Ctrl+O".move-workspace-down = [];
        "Mod+Ctrl+I".move-workspace-up = [];

        "Mod+BracketLeft".consume-or-expel-window-left = [];
        "Mod+BracketRight".consume-or-expel-window-right = [];
        "Mod+Comma".consume-window-into-column = [];
        "Mod+Period".expel-window-from-column = [];

        "Mod+R".switch-preset-column-width = [];
        "Mod+Ctrl+R".reset-window-height = [];
        "Mod+F".maximize-column = [];
        "Mod+Shift+F".fullscreen-window = [];
        "Mod+Ctrl+F".expand-column-to-available-width = [];

        "Mod+C".center-column = [];
        "Mod+Ctrl+C".center-visible-columns = [];

        "Mod+Minus".set-column-width = "-10%";
        "Mod+Equal".set-column-width = "+10%";
        "Mod+Shift+Minus".set-window-height = "-10%";
        "Mod+Shift+Equal".set-window-height = "+10%";

        "Mod+V".toggle-window-floating = [];
        "Mod+Shift+V".switch-focus-between-floating-and-tiling = [];

        "Mod+W".toggle-column-tabbed-display = [];
      };

      xwayland-satellite.path = lib.getExe niriPkgs.xwayland-satellite-unstable;
    };
  };

  programs.ashell = {
    enable = true;

    settings = {
      position = "Bottom";

      modules = {
        left = ["Workspaces" "SystemInfo"];
        center = ["WindowTitle"];
        right = [
          "Tray"
          [
            "Tempo"
            "Privacy"
            "Settings"
          ]
        ];
      };
    };
  };
  programs.fuzzel = {
    enable = true;
    settings.main = {
      terminal = "${pkgs.kitty}/bin/kitty";
      dpi-aware = true;
    };
  };
  services.fnott.enable = true;

  programs.swaylock.enable = true;
}
