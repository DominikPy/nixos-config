{ config, lib, pkgs, ... }:

{
  imports =
    [      
	./hardware-configuration.nix
    ];

 # boot.loader.systemd-boot.enable = true;
 # boot.loader.efi.canTouchEfiVariables = true;

boot.loader.grub.enable = true;
boot.loader.grub.efiSupport = true;
boot.loader.grub.efiInstallAsRemovable = true;
boot.loader.grub.device = "nodev";

services.getty.autologinUser = "dominik";
 


networking.hostName = "nixos";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Prague";

programs.hyprland = {
	enable = true;
	xwayland.enable = true;
	};

users.users.dominik = {
     isNormalUser = true;
     extraGroups = [ "wheel" ];
     packages = with pkgs; [
       tree
     ];
   };

   programs.firefox.enable = true;
environment.systemPackages = with pkgs; [
	neovim
	wget
	foot
	waybar
	kitty
	];

services.openssh.enable = true;

system.stateVersion = "26.05";
}
