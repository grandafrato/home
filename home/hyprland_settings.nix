{pkgs, ...}: {
  # Monitor Settings
  monitor = [
    "eDP-1, preferred, auto, 1"
    "DP-1, 1920x1080@60, auto-up, 1"
    ",preferred, auto, 1, mirror, eDP-1"
  ];
  xwayland.force_zero_scaling = true;

  # Startup
  exec-once = [
    "waybar"
    "systemctl --user enable --now hyprpaper.service"
    "systemctl --user enable --now hypridle.service"
    "systemctl --user enable --now hyprpolkitagent.service"
  ];

  general = {
    gaps_out = 6;
    gaps_in = 3;

    border_size = 2;
    resize_on_border = false;

    allow_tearing = false;

    layout = "dwindle";
  };

  decoration = {
    rounding = 10;

    active_opacity = 1.0;
    inactive_opacity = 0.9;

    blur.enabled = false;
  };

  # animations.enabled = false;

  dwindle = {
    pseudotile = true;
    preserve_split = true;
  };

  master.new_status = "master";

  misc = {
    disable_hyprland_logo = true;
    vfr = true;
  };

  # Applications
  "$terminal" = "${pkgs.kitty}/bin/kitty";
  "$fileManager" = "dolphin";
  "$browser" = "firefox";

  # Input Tuning
  input = {
    kb_layout = "us";
    sensitivity = 1.0;
    touchpad.natural_scroll = true;
  };

  cursor.hide_on_key_press = true;

  # Key Binds
  # Format is bind[flags]
  "$mod" = "SUPER";
  "$mod_shift" = "SUPER_SHIFT";
  bind =
    [
      # Application Binds
      "$mod, F, exec, $browser"
      "$mod, T, exec, $terminal"
      "$mod, E, exec, $fileManager"
      "$mod, A, exec, ${pkgs.fuzzel}/bin/fuzzel"

      # Manage Applications
      "$mod, Q, killactive"
      "$mod, V, togglefloating"
      "$mod, P, pseudo, # dwindle"
      "$mod, G, togglesplit, # dwindle"

      # Move Window Focus
      "$mod, H, movefocus, l"
      "$mod, L, movefocus, r"
      "$mod, K, movefocus, u"
      "$mod, J, movefocus, d"

      # Swap Window Around Workspace
      "$mod_shift, H, swapwindow, l"
      "$mod_shift, L, swapwindow, r"
      "$mod_shift, K, swapwindow, u"
      "$mod_shift, J, swapwindow, d"

      # Move Window to Next or Previous Workspace
      "$mod_shift, O, split-movetoworkspace, +1"
      "$mod_shift, I, split-movetoworkspace, -1"

      # Change Focus to Next or Previous Workspace
      "$mod, O, split-workspace, +1"
      "$mod, I, split-workspace, -1"

      # Brightness Control
      ", XF86MonBrightnessUp, exec, ${pkgs.brillo}/bin/brillo -q -A 5"
      ", XF86MonBrightnessDown, exec, ${pkgs.brillo}/bin/brillo -q -U 5"

      # Logout
      "$mod, U, exec, ${pkgs.wlogout}/bin/wlogout"
    ]
    ++ (builtins.concatLists (
      builtins.genList (
        x: let
          ws = let
            c = (x + 1) / 10;
          in
            builtins.toString (x + 1 - (c * 10));
        in [
          "$mod, ${ws}, split-workspace, ${toString (x + 1)}"
          "$mod_shift, ${ws}, split-movetoworkspace, ${toString (x + 1)}"
        ]
      )
      10
    ));

  # Media Control
  bindel = [
    ", XF86AudioRaiseVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
    ", XF86AudioLowerVolume, exec, ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
  ];
  bindl = [
    ", XF86AudioMute, exec, ${pkgs.wireplumber}/bin/wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
  ];

  # Move and Resize Windows with Mouse
  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
  ];

  # Prevent Maximize Event
  windowrulev2 = ["suppressevent maximize, class:.*"];

  debug.full_cm_proto = "true";
}
