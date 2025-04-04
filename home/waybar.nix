let
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
in
{
  enable = true;
  settings.minibar = {
    layer = "top";
    position = "top";
    passthrough = false;
    height = 40;
    modules-left = [
      "clock"
      "hyprland/workspaces"
      "idle_inhibitor"
    ];
    modules-center = [ "hyprland/window" ];
    modules-right = [
      "wireplumber"
      "backlight"
      "network"
      "battery"
    ];

    "hyprland/workspaces" = {
      format = "{name}";
      format-icons = {
        default = " ";
        active = " ";
        urgent = " ";
      };
      on-scroll-up = "hyprctl dispatch workspace e+1";
      on-scroll-down = "hyprctl dispatch workspace e-1";
    };

    clock = {
      format = '' {:L%I:%M %p}'';
      tooltip = true;
      tooltip-format = "<big>{:%A, %d.%B %Y }</big>\n<tt><small>{calendar}</small></tt>";
    };

    idle_inhibitor = {
      format = "{icon}";
      format-icons = {
        activated = "";
        deactivated = "";
      };
    };

    "hyprland/window" = {
      separate-outputs = false;
      max-length = 50;
      rewrite."" = "No Windows Focused";
    };

    network = {
      format-icons = [
        "󰤯"
        "󰤟"
        "󰤢"
        "󰤥"
        "󰤨"
      ];
      format-ethernet = " {bandwidthDownOctets}";
      format-wifi = "{icon} {signalStrength}%";
      format-disconnected = "󰤮";
      tooltip = false;
    };

    wireplumber = {
      format = "{icon} {volume}%";
      format-muted = "";
      format-icons = [
        ""
        ""
        ""
      ];
    };

    backlight = {
      device = "intel_backlight";
      format = "{icon} {percent}%";
      format-icons = [
        ""
        ""
      ];
    };

    battery = {
      states = {
        warning = 30;
        critical = 15;
      };
      format = "{icon} {capacity}%";
      format-charging = "󰂄 {capacity}%";
      format-plugged = "󱘖 {capacity}%";
      format-icons = [
        "󰁺"
        "󰁻"
        "󰁼"
        "󰁽"
        "󰁾"
        "󰁿"
        "󰂀"
        "󰂁"
        "󰂂"
        "󰁹"
      ];
      on-click = "wlogout";
      tooltip = false;
    };
  };
  style = ''
    * {
      font-family: JetBrainsMono Nerd Font Mono;
      font-size: 16px;
      border-radius: 0px;
      border: none;
      min-height: 0px;
    }
    window#waybar {
      background: rgba(0,0,0,0);
    }
    #workspaces {
      color: #282936;
      background: #3a3c4e;
      margin: 4px 4px;
      padding: 5px 5px;
      border-radius: 16px;
    }
    #workspaces button {
      font-weight: bold;
      padding: 0px 5px;
      margin: 0px 3px;
      border-radius: 16px;
      color: #282936;
      background: linear-gradient(45deg, #ea51b2, #62d6e8);
      opacity: 0.5;
      transition: ${betterTransition};
    }
    #workspaces button.active {
      font-weight: bold;
      padding: 0px 5px;
      margin: 0px 3px;
      border-radius: 16px;
      color: #282936;
      background: linear-gradient(45deg, #ea51b2, #62d6e8);
      transition: ${betterTransition};
      opacity: 1.0;
      min-width: 40px;
    }
    #workspaces button:hover {
      font-weight: bold;
      border-radius: 16px;
      color: #282936;
      background: linear-gradient(45deg, #ea51b2, #62d6e8);
      opacity: 0.8;
      transition: ${betterTransition};
    }
    tooltip {
      background: #282936;
      border: 1px solid #ea51b2;
      border-radius: 12px;
    }
    tooltip label {
      color: #ea51b2;
    }
    #window {
      font-weight: bold;
      margin: 0px;
      margin-left: 7px;
      padding: 0px 40px;
      background: #626483;
      color: #dee2e6;
      border-radius: 0px 0px 40px 40px;
    }
    #network, #battery, #backlight, #wireplumber {
      font-weight: bold;
      background: #00f769;
      color: #282936;
      margin: 4px 0px;
      margin-right: 7px;
      border-radius: 10px 24px 10px 24px;
      padding: 0px 18px;
    }
    #clock {
      font-weight: bold;
      color: #0D0E15;
      background: linear-gradient(90deg, #b45bcf, #a1efe4);
      margin: 0px;
      padding: 0px 30px 0px 15px;
      border-radius: 0px 0px 40px 0px;
    }
    #idle_inhibitor {
      font-weight: bold;
      color: #0D0E15;
      background: linear-gradient(90deg, #b45bcf, #a1efe4);
      margin: 4px 4px;
      padding: 5px 10px;
      border-radius: 16px;
    }
  '';
}
