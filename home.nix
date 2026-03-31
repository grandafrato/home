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
    cosmic-files
    feather
    gajim
    kdePackages.ark
    kdePackages.kleopatra
    monero-cli
    mumble
    p2pool
    pkgsRocm.blender
    prismlauncher
    protonvpn-gui
    raider
    rhythmbox
    rpcs3
    tor-browser
    tree
    vlc
    wayvr
    wl-clipboard
  ];

  services.protonmail-bridge.enable = true;

  qt.enable = true;

  programs.firefox = {
    enable = true;
    profiles.i2p = {
      path = "oc6x9v4p.i2p";
      id = 1;
    };
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
  stylix.targets.firefox.profileNames = ["default" "i2p"];

  xdg.desktopEntries = {
    i2p-browser = {
      name = "i2p Browser";
      genericName = "Web Browser";
      exec = "firefox -p i2p";
    };
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

      # Kitty Stuff
      icat = "kitten icat";
      ssh = "kitten ssh";

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
    image = ./backgrounds/space.jpg;
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
