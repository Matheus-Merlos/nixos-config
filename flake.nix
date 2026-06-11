{
  description = "Minha Configuração Pessoal do NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs; 
      };
      modules = [
        home-manager.nixosModules.home-manager
        ./hosts/nixos/configuration.nix
        ./hosts/nixos/hardware-configuration.nix
      ];
    };
  };
}