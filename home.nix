{
  config,
  pkgs,
  lib,
  nixgl,
  nixvim,
  ...
}: {
  home.username = "lachlan";
  home.homeDirectory = "/home/lachlan";

  home.stateVersion = "24.11";

  targets.genericLinux.enable = true;

  imports = [nixvim.homeManagerModules.nixvim];

  nixGL.packages = nixgl.packages;
  nixGL.defaultWrapper = "mesa";
  nixGL.installScripts = ["mesa"];
  nixGL.vulkan.enable = true;

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    (config.lib.nixGL.wrap blender-hip)
    (config.lib.nixGL.wrap feather)
    (config.lib.nixGL.wrap rpcs3)
    monero-cli
    (callPackage ./p2pool.nix {})
  ];

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
    image = ./mountain-background.jpg;
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
    font.size = lib.mkForce 11;
  };

  programs.nixvim = import ./nixvim.nix;

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

  programs.git = {
    enable = true;
    userEmail = "github.defender025@passmail.net";
    userName = "Lachlan Wilger";
    signing = {
      key = "2EE29D3CE347115D";
      signByDefault = true;
    };
    ignores = ["*~" "*.swp"];
    extraConfig.init.defaultBranch = "main";
  };
}
