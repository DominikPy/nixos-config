{
  description = "Minimal ThinkPad T14 Gen 5 System Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Home Manager, kept in sync with the nixpkgs unstable branch
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # LazyVim, kept in sync with the nixpkgs unstable branch
    inputs.lazyvim.url = "github:pfassina/lazyvim-nix";

    # Community hardware optimizations
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, lazyvim, ... }@inputs: {
    nixosConfigurations = {
      thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix
          
          # Include ThinkPad & Intel specific optimizations
          nixos-hardware.nixosModules.lenovo-thinkpad-t14
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-pc-ssd

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [ lazyvim.homeManagerModules.default ];
            home-manager.users.dominik = import ./home.nix;
            home-manager.backupFileExtension = "bak";
          }
        ];
      };
    };
  };
}
