{ config, pkgs, ... }:

{
  # === System Core & Boot ===
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.11";
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # === Hardware & Power Management ===
  hardware.graphics.enable = true;
  
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
  services.tlp.pd.enable = true;
  services.thermald.enable = true; 

  # === Audio (Pipewire) ===
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # === Networking & Locale ===
  networking.hostName = "thinkpad";
  networking.extraHosts = "127.0.0.1 thinkpad";
  networking.networkmanager.enable = true;
  time.timeZone = "Europe/Prague"; 
  i18n.defaultLocale = "en_US.UTF-8";

  # === User & Security ===
  users.users.dominik = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" ];
  };

  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;

  # === Desktop Environment ===
  programs.hyprland.enable = true;
  
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
        user = "greeter";
      };
    };
  };

  # Hint electron apps (like VS Code, Discord, etc.) to use Wayland natively
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  # === System Packages ===
  environment.systemPackages = with pkgs; [
    git
  ];
}
