{
  description = "nix config for lachlan";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    nixos-hardware = {
      url = "github:nixos/nixos-hardware/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };
    niri-nixpkgs.url = "github:nixos/nixpkgs?rev=c8c029256f3d21e57f0901e97d181a2d336bfd62";
    niri-nix = {
      url = "git+https://codeberg.org/BANanaD3V/niri-nix";
      inputs.nixpkgs.follows = "niri-nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    stylix,
    nixvim,
    nixos-hardware,
    lix-module,
    niri-nix,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    niriPkgs = niri-nix.packages.${system};
  in {
    nixosConfigurations.chargeman-ken = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit niriPkgs;};
      modules = [
        ./configuration.nix
        nixos-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useUserPackages = true;
            users."lachlan" = ./home.nix;
            sharedModules = [
              stylix.homeModules.stylix
              niri-nix.homeModules.default
              niri-nix.homeModules.stylix
            ];
            extraSpecialArgs = {inherit nixvim niriPkgs;};
          };
        }
        stylix.nixosModules.stylix
        lix-module.nixosModules.default
      ];
    };
    formatter.${system} = pkgs.alejandra;
  };
}
