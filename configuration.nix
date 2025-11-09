# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  pkgs,
  lib,
  winappsPkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.kernelParams = ["thunderbolt.host_reset=0"];
  boot.extraModprobeConfig = "options amdgpu vis_vramlimit=256"; # Small BAR for AMD eGPU
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking = {
    hostName = "chargeman-ken";
    networkmanager.enable = true;
    interfaces.wlp0s20f3.useDHCP = true;
    firewall.trustedInterfaces = ["virbr0"];
  };

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.power-profiles-daemon.enable = false;
  services.upower.enable = true;
  services.thermald.enable = true;
  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 95;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      # Optional helps save long term battery health
      START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
      STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
    };
  };

  services.hardware.bolt.enable = true;

  services.logind.settings.Login.HandleLidSwitchExternalPower = "ignore";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lachlan = {
    isNormalUser = true;
    description = "Lachlan Wilger";
    extraGroups = [
      "networkmanager"
      "wheel"
      "render"
      "adbusers"
      "kvm"
      "libvirtd"
      "video"
      "gamemode"
    ];
    packages = with pkgs; [podman-tui];
    shell = pkgs.nushell;
  };
  users.groups.libvirtd.members = ["lachlan"];

  # Allow unfree packages
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [inputs.niri.overlays.niri];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    extraConfig.pipewire = {
      "98-sample-rates" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.allowed-rates" = [
            44100
            48000
            96000
            192000
            384000
          ];
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 4096;
          "default.clock.max-quantum" = 8192;
        };
      };
    };
  };

  security.polkit.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Enable = "Source,Sink,Media,Socket";
  };

  programs.kdeconnect.enable = true;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  hardware.brillo.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    variables = {
      RADV_PERFTEST = "dmashaders";
      LIBVERT_DEFAULT_URI = "qemu:///system";
    };
    systemPackages = with pkgs; [
      vim
      git
      unzip
      libreoffice-fresh
      hunspell
      hunspellDicts.en_US
      protonup-qt
      winappsPkgs.winapps
      winappsPkgs.winapps-launcher
      freerdp
    ];
  };

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "colormix";
      bigclock = "en";
      brightness_down_cmd = "${pkgs.brillo}/bin/brillo -q -U 5";
      brightness_up_cmd = "${pkgs.brillo}/bin/brillo -q -A 5";
    };
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-stable;
  };

  services.interception-tools = let
    itools = pkgs.interception-tools;
    itools-caps = pkgs.interception-tools-plugins.caps2esc.overrideAttrs (_: {
      cmakeFlags = ["-DCMAKE_POLICY_VERSION_MINIMUM=3.5"];
    });
  in {
    enable = true;
    plugins = [itools-caps];
    udevmonConfig = pkgs.lib.mkDefault ''
      - JOB: "${itools}/bin/intercept -g $DEVNODE | ${itools-caps}/bin/caps2esc -m 0 | ${itools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
  programs.gamescope.enable = true;

  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general.renice = 10;
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 1;
        amd_performance_level = "auto";
      };
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
      };
    };
  };

  services.gvfs.enable = true;

  services.fwupd.enable = true;

  # VR stuff
  services.wivrn = {
    enable = true;
    defaultRuntime = true;
    openFirewall = true;
  };
  # boot.kernelPatches = [
  #   {
  #     name = "amdgpu-ignore-ctx-privileges";
  #     patch = pkgs.fetchpatch {
  #       name = "cap_sys_nice_begone.patch";
  #       url = "https://github.com/Frogging-Family/community-patches/raw/master/linux61-tkg/cap_sys_nice_begone.mypatch";
  #       hash = "sha256-Y3a0+x2xvHsfLax/uwycdJf3xLxvVfkfDVqjkxNaYEo=";
  #     };
  #   }
  # ];

  services.transmission = {
    enable = true;
    package = pkgs.transmission_4-qt;
    openPeerPorts = true;
  };

  programs.adb.enable = true;

  # Enable virtual machines
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = ["virb0"];
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;
    };
  };
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation = {
    containers.enable = true;
    podman.enable = true;
  };

  services.beesd.filesystems.root = {
    spec = "UUID=\"bd1f5019-9457-4b95-b8b1-571fcc411d58\"";
    hashTableSizeMB = 2048;
    verbosity = "crit";
    extraOptions = [
      "--loadavg-target"
      "5.0"
    ];
  };

  specialisation.vm-passthrough.configuration = {
    boot.initrd.kernelModules = [
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];
    boot.kernelParams = let
      gpu_and_component_ids = [
        "8086:462f"
        "1002:73df"
        "1002:ab28"
      ];
    in [
      "intel_iommu=on"
      "iommu=pt"
      ("vifio-pci.ids=" + lib.concatStringsSep "," gpu_and_component_ids)
    ];

    hardware.amdgpu.initrd.enable = false;
    boot.blacklistedKernelModules = ["amdgpu"];
  };

  # Graphics
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [vpl-gpu-rt];
  };
  hardware.amdgpu.initrd.enable = lib.mkDefault true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
