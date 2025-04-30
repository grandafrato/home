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
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:nixos/nixos-hardware/master";
    stardust.url = "github:StardustXR/telescope";
  };

  outputs = {
    nixpkgs,
    home-manager,
    stylix,
    nixvim,
    auto-cpufreq,
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
        stylix.homeManagerModules.stylix
        ./home.nix
      ];
    };
    nixosConfigurations.chargeman-ken = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        auto-cpufreq.nixosModules.default
        nixos-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen
        nixos-hardware.nixosModules.common-gpu-amd
      ];
    };
    formatter.${system} = pkgs.alejandra;
  };
}
