{
  description = "nix config for lachlan";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
  };

  outputs = {
    nixpkgs,
    home-manager,
    stylix,
    nixvim,
    hyprland,
    nixos-hardware,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    homeConfigurations."lachlan" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = {inherit nixvim;};
      modules = [
        stylix.homeModules.stylix
        ./home.nix
      ];
    };
    nixosConfigurations.chargeman-ken = nixpkgs.lib.nixosSystem {
      specialArgs = {
        inherit inputs;
        hyprlandPkgs = hyprland.packages.${system};
        hyprlandNixpkgs = hyprland.inputs.nixpkgs.legacyPackages.${system};
      };
      modules = [
        ./configuration.nix
        nixos-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen
      ];
    };
    formatter.${system} = pkgs.alejandra;
  };
}
