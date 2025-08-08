{
  config,
  pkgs,
  lib,
  nixvim,
  split-monitor-workspacesPkgs,
  ...
}: {
  home.username = "lachlan";
  home.homeDirectory = "/home/lachlan";

  home.stateVersion = "24.11";

  imports = [nixvim.homeModules.nixvim];

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    (llama-cpp.override {
      rocmSupport = true;
      rocmPackages = pkgs.rocmPackages;
    })
    blender-hip
    feather
    rpcs3
    kdePackages.dolphin
    kdePackages.kleopatra
    kdePackages.ark
    kdePackages.tokodon
    #kdePackages.elisa
    monero-cli
    (callPackage ./p2pool.nix {})
    tree
    prismlauncher
    ungoogled-chromium
    zoom-us
    slack
    rhythmbox
    linux-wifi-hotspot
    wlx-overlay-s
    qalculate-gtk
    raider
    rnote
    tor-browser
    gnome-clocks
    veusz
    freecad-wayland
    openscad
    kicad
    dissent
    pods
    vlc
  ];

  programs.firefox = {
    enable = true;
    profiles.default = {
      path = "xvud1yza.default";
      search.force = true;
      search.default = "ddg";
      search.engines = {
        nix-packages = {
          name = "Nix Packages";
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
                {
                  name = "channel";
                  value = "unstable";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@np"];
        };
      };
    };
  };
  stylix.targets.firefox.profileNames = ["default"];

  programs.nushell = {
    enable = true;
    shellAliases = {
      z = "zellij";
      v = "nvim";
      hm = "home-manager";
      nd = "nix develop -c ${pkgs.nushell}/bin/nu";

      # Git Aliases
      g = "git";
      ga = "git add";
      gaa = "git add -A";
      gc = "git commit";
      gcl = "git clone";
      gp = "git push";
    };
    environmentVariables.EDITOR = "nvim";
    settings = {
      show_banner = false;
      edit_mode = "vi";
      completions = {
        case_sensitive = false;
        quick = true;
        partial = true;
        algorithm = "fuzzy";
        external = {
          enable = true;
          max_results = 100;
        };
      };
    };
    extraConfig = ''
      $env.config.completions.external.completer = {|spans|
        carapace $spans.0 nushell ...$spans | from json
      }
      $env.PATH = ($env.PATH |
      split row (char esep) |
      append /usr/bin/env
      )
    '';
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  stylix = {
    enable = true;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/dracula.yaml";
    image = ./backgrounds/Mountains.png;
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      serif = {
        package = pkgs.carlito;
        name = "Carlito";
      };
      sansSerif = {
        package = pkgs.poly;
        name = "Poly";
      };
    };
    cursor = {
      name = "macOS";
      package = pkgs.apple-cursor;
      size = 32;
    };
  };

  qt.enable = true;

  programs.btop.enable = true;
  programs.bat.enable = true;

  programs.kitty = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.kitty;
    shellIntegration.enableBashIntegration = true;
    font.size = lib.mkForce 10;
  };

  programs.nixvim = import ./nixvim.nix {inherit pkgs;};

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    settings = {
      character.disabled = true;
      package.disabled = true;
      elixir.disabled = true;
    };
  };

  programs.zellij = {
    enable = true;
    settings = {
      pane_frames = false;
      default_layout = "compact";
      default_shell = "nu";
      show_startup_tips = false;
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  programs.git = {
    enable = true;
    userEmail = "github.defender025@passmail.net";
    userName = "Lachlan Wilger";
    signing = {
      key = "19827F0EE0558030";
      signByDefault = true;
    };
    ignores = [
      "*~"
      "*.swp"
    ];
    extraConfig.init.defaultBranch = "main";
  };

  services.mpris-proxy.enable = true;

  programs.fuzzel = {
    enable = true;
    settings.main = {
      layer = "overlay";
      terminal = "${pkgs.kitty}/bin/kitty";
      font = lib.mkForce "JetBrainsMono NF SemiBold:size=12";
      width = 40;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = true;
    settings = import ./home/hyprland_settings.nix pkgs;
    plugins = [split-monitor-workspacesPkgs.split-monitor-workspaces];
  };
  stylix.targets.hyprland.enable = false;

  programs.waybar = import ./home/waybar.nix;
  stylix.targets.waybar.enable = false;

  programs.wlogout.enable = true;

  services.dunst = {
    enable = true;
    settings.global.corner_radius = 8;
  };

  services.hyprpolkitagent.enable = true;

  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      preload = "${./backgrounds/Mountains.png}";
      wallpaper = ",${./backgrounds/Mountains.png}";
    };
  };
  stylix.targets.hyprpaper.enable = false;

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        # After 2.5 minutes, set monitor to minimum brightness, and return to
        # to previous brightness on awake.
        {
          timeout = 150;
          on-timeout = "brillo -O && brillo -S 0.01";
          on-resume = "brillo -I";
        }
        # After 5 minutes, lock the screen.
        {
          timeout = 300;
          on-timeout = "loginctl lock-session";
        }
        # After 5 and 1/2 minutes, turn the screen off, but turn it bacl on if
        # activity is detected after timeout has been fired.
        {
          timeout = 330;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        # Suspend computer after 15 minutes.
        {
          timeout = 900;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      source = "${./home/hyprlock/mocha.conf}";
      "$bg_path" = "${./backgrounds/Clearnight.jpg}";
      "$face_path" = "${./home/hyprlock/face.png}";
    };
    extraConfig = builtins.readFile ./home/hyprlock/hyprlock.conf;
  };

  xdg.configFile."libvirt/qemu.conf".text = ''
    # Adapted from /var/lib/libvirt/qemu.conf
    # Note that AAVMF and OVMF are for Aarch64 and x86 respectively
    nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]
  '';

  xdg.configFile."openvr/openvrpaths.vrpath".text = ''
    {
      "config" :
      [
        "${config.xdg.dataHome}/Steam/config"
      ],
      "external_drivers" : null,
      "jsonid" : "vrpathreg",
      "log" :
      [
        "${config.xdg.dataHome}/Steam/logs"
      ],
      "runtime" :
      [
        "${pkgs.opencomposite}/lib/opencomposite"
      ],
      "version" : 1
    }
  '';

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
