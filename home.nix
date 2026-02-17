{
  config,
  pkgs,
  lib,
  nixvim,
  niri,
  ...
}: {
  home.username = "lachlan";
  home.homeDirectory = "/home/lachlan";

  home.stateVersion = "24.11";

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [niri.overlays.niri];
  };

  imports = [nixvim.homeModules.nixvim ./home/desktop.nix];

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    pkgsRocm.blender
    feather
    rpcs3
    kdePackages.ark
    cosmic-files
    kdePackages.kleopatra
    monero-cli
    p2pool
    tree
    prismlauncher
    rhythmbox
    wayvr
    raider
    tor-browser
    #freecad-wayland
    #openscad
    #kicad
    discord
    vlc
    inkscape
    wl-clipboard
    protonvpn-gui
  ];

  services.protonmail-bridge.enable = true;

  qt.enable = true;

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
        github = {
          name = "GitHub";
          urls = [
            {
              template = "https://github.com/search";
              params = [
                {
                  name = "q";
                  type = "{searchTerms}";
                }
                {
                  name = "type";
                  type = "repositories";
                }
              ];
            }
          ];
          icon = ./home/icons/github.png;
          definedAliases = ["@gh"];
        };
      };
    };
  };
  stylix.targets.firefox.profileNames = ["default"];

  services.easyeffects = let
    gentleDynamics = pkgs.fetchFromGitHub {
      owner = "droidwayin";
      repo = "GentleDynamics";
      rev = "a57272822a7f8ed8aa886414709647032716a776";
      hash = "sha256-c4B3vk/kef7B1u0OiYdb7VWa7qiQeHZ0yxKB5vKZyeE=";
    };
    voice = pkgs.fetchzip {
      url = "https://gist.github.com/jtrv/47542c8be6345951802eebcf9dc7da31/archive/c0a71a61e30856989a6dc109b59873e3f3ea697d.zip";
      hash = "sha256-aaViZbmK0X5y4uYe1bLabEpPGIwhXcztxxW3euPHTvU=";
    };
  in {
    enable = true;
    extraPresets = {
      GentleDynamics = builtins.fromJSON (
        builtins.readFile "${gentleDynamics}/GentleDynamics.json"
      );
      "GentleDynamics Feather Loudness" = builtins.fromJSON (
        builtins.readFile "${gentleDynamics}/GentleDynamics Feather Loudness.json"
      );
      "GentleDynamics Dialogue Clarity Engine" = builtins.fromJSON (
        builtins.readFile "${gentleDynamics}/GentleDynamics Dialogue Clarity Engine.json"
      );
      "EasyEffects Microphone Preset: Masc NPR Voice + Noise Reduction" = builtins.fromJSON (
        builtins.readFile "${voice}/EasyEffects Microphone Preset: Masc NPR Voice + Noise Reduction.json"
      );
    };
    preset = "GentleDynamics Feather Loudness";
  };

  programs.thunderbird = {
    enable = true;
    profiles.default.isDefault = true;
  };

  programs.helix.enable = true;

  programs.opencode.enable = true;

  programs.nushell = {
    enable = true;
    shellAliases = {
      z = "zellij";
      v = "nvim";
      nd = "nix develop -c ${pkgs.nushell}/bin/nu";

      # Git Aliases
      g = "git";
      ga = "git add";
      gaa = "git add -A";
      gc = "git commit";
      gcl = "git clone";
      gd = "git diff";
      gl = "git log";
      gp = "git push";
    };
    environmentVariables.EDITOR = "nvim";
    settings = {
      show_banner = false;
      edit_mode = "vi";
      use_kitty_protocol = true;
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
    image = ./backgrounds/awesome-tree.jpg;
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
        package = pkgs.vegur;
        name = "Vegur";
      };
    };
    cursor = {
      name = "macOS";
      package = pkgs.apple-cursor;
      size = 24;
    };
  };

  programs.btop.enable = true;
  programs.bat.enable = true;

  programs.kitty = {
    enable = true;
    package = config.lib.nixGL.wrap pkgs.kitty;
    shellIntegration.enableBashIntegration = true;
    font.size = lib.mkForce 10;
    settings.hide_window_decorations = "yes";
  };

  programs.nixvim = import ./nixvim.nix {inherit pkgs;};

  programs.zed-editor = {
    enable = true;
    extensions = [
      "elixir"
      "nix"
      "ziggy"
      "zig"
    ];
    userSettings = {
      telemetry.metrics = false;
      vim_mode = true;
      terminal.shell.program = "nu";
      buffer_font_size = lib.mkForce 12;
    };
  };

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
      "compact-bar location=\"zellij:compact-bar\"".tooltip = "F1";
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
    signing = {
      key = "19827F0EE0558030";
      signByDefault = true;
    };
    ignores = [
      "*~"
      "*.swp"
    ];
    settings = {
      user.email = "github.defender025@passmail.net";
      user.name = "Lachlan Wilger";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
    };
  };

  services.mpris-proxy.enable = true;

  xdg.configFile."libvirt/qemu.conf".text = ''
    # Adapted from /var/lib/libvirt/qemu.conf
    # Note that AAVMF and OVMF are for Aarch64 and x86 respectively
    nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]
  '';

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
}
