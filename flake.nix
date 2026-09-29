{
  description = "Minimal ThinkPad T14 Gen 5 System Config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # Home Manager, kept in sync with the nixpkgs unstable branch
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      home-manager.backupFileExtension = "bak";
    };

    # Community hardware quirks and optimizations
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs: {
    nixosConfigurations = {
      # Replace "thinkpad" with your actual hostname if you prefer
      thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; # Pass flake inputs to our modules
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix
          
          # Include ThinkPad & Intel specific optimizations
          nixos-hardware.nixosModules.lenovo-thinkpad-t14
          nixos-hardware.nixosModules.common-cpu-intel
          nixos-hardware.nixosModules.common-pc-ssd

          # Integrate Home Manager as a NixOS module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            # Replace "yourusername" with your actual user name
            home-manager.users.dominik = import ./home.nix;
          }
        ];
      };
    };
  };
}
