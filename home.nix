{
  config,
  pkgs,
  lib,
  nixvim,
  ...
}: {
  home.username = "lachlan";
  home.homeDirectory = "/home/lachlan";

  home.stateVersion = "24.11";

  imports = [nixvim.homeManagerModules.nixvim];

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    (alpaca.override
      {
        ollama = pkgs.ollama-rocm;
      })
    blender-hip
    feather
    rpcs3
    kdePackages.dolphin
    kdePackages.elisa
    kdePackages.kleopatra
    monero-cli
    (callPackage ./p2pool.nix {})
    tree
    prismlauncher
    ungoogled-chromium
    zoom-us
    slack
  ];

  programs.firefox.enable = true;

  programs.zsh = {
    enable = true;
    shellAliases = {
      z = "zellij";
      v = "nvim";
      t = "tmux";
      hm = "home-manager";

      # Git Aliases
      g = "git";
      ga = "git add";
      gaa = "git add -A";
      gc = "git commit";
      gcl = "git clone";
      gp = "git push";

      # nix-shell use zsh
      nix-shell = "nix-shell --run ${pkgs.zsh}/bin/zsh";
    };
    initExtra = ''
      # run zsh in nix develop environments
      nix() {
        if [[ $1 == "develop" ]]; then
          shift
          command nix develop -c ${pkgs.zsh}/bin/zsh "$@"
        else
          command nix "$@"
        fi
      }
      # Color ls command and derivatives
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
    '';
    sessionVariables = {
      EDITOR = "nvim";
      LS_COLORS = builtins.readFile ./dircolors.default;
    };
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
  };

  qt.enable = true;

  programs.btop.enable = true;
  programs.bat.enable = true;

  programs.kitty = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.kitty;
    shellIntegration.enableBashIntegration = true;
    shellIntegration.enableZshIntegration = true;
    settings.shell = "zsh";
    font.size = lib.mkForce 10;
  };

  programs.nixvim = import ./nixvim.nix {inherit pkgs;};

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      package.disabled = true;
      elixir.disabled = true;
    };
  };

  programs.zellij = {
    enable = true;
    enableBashIntegration = false;
    enableZshIntegration = false;
    settings = {
      pane_frames = false;
      default_layout = "compact";
      default_shell = "zsh";
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
      key = "2EE29D3CE347115D";
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
  };
  stylix.targets.hyprland.enable = false;

  programs.waybar = import ./home/waybar.nix;
  stylix.targets.waybar.enable = false;

  programs.wlogout.enable = true;

  services.dunst = {
    enable = true;
    settings.global.corner_radius = 8;
  };

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
        # Suspend computer after 30 minutes.
        {
          timeout = 1800;
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
}
