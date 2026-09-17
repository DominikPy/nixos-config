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

 # services.getty.autologinUser = "dominik";
 
services.displayManager.sddm = {
  enable = true;
  wayland.enable = true;
};

# Force SDDM to default to the Hyprland session
services.displayManager.defaultSession = "hyprland";

networking.hostName = "mainframe";

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
	];

fonts.packages = with pkgs; [
	nerd-fonts.jetbrains-mono
	];

services.openssh.enable = true;
nix.settings.experimental-features = [ "nix-command" "flakes" ];
system.stateVersion = "26.05";
}
