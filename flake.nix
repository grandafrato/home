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
    stardust.url = "github:StardustXR/telescope";
  };

  outputs = {
    nixpkgs,
    home-manager,
    stylix,
    nixvim,
    hyprland,
    nixos-hardware,
    stardust,
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

      extraSpecialArgs = {
        inherit nixvim;
        stardustPkgs = stardust.packages.${system};
      };
      modules = [
        stylix.homeModules.stylix
        ./home.nix
      ];
    };
    nixosConfigurations.chargeman-ken = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        nixos-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen
        nixos-hardware.nixosModules.common-gpu-amd
      ];
    };
    formatter.${system} = pkgs.alejandra;
  };
}
