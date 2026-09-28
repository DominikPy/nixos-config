{ config, pkgs, ... }:

{
  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thinkpad";
  networking.networkmanager.enable = true;

  # Set your time zone and locale
  time.timeZone = "Europe/Prague"; 
  i18n.defaultLocale = "en_US.UTF-8";

  # Define your user account (Change "yourusername")
  users.users.dominik = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" ];
  };

  # Enable the Hyprland system module (required for proper PAM and hardware acceleration)
  programs.hyprland.enable = true;

  # Power Management for Intel ThinkPad
  # TLP conflicts with power-profiles-daemon, so we ensure PPD is off.
  services.power-profiles-daemon.enable = false;
  services.tlp.enable = true;
  # Thermald is highly recommended for modern Intel CPUs to prevent thermal throttling
  services.thermald.enable = true; 

  # Fingerprint Reader
  services.fprintd.enable = true;
  # Enable fingerprint authentication for login and sudo
  security.pam.services.login.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;

  # Minimal Greeter (tuigreet) to launch Hyprland
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd start-hyprland";
	user = "greeter";
      };
    };
  };

  # Enable sound with pipewire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Essential system utilities
  environment.systemPackages = with pkgs; [
    git
  ];

  # Hardware acceleration
  hardware.graphics.enable = true;

  # Allow unfree packages (if you need proprietary firmware or software)
  nixpkgs.config.allowUnfree = true;

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

 system.stateVersion = "26.11"; # Do not change this value
}
