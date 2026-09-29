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

# === TLP Battery Charge Thresholds ===
  services.tlp.settings = {
    START_CHARGE_THRESH_BAT0 = 75;
    STOP_CHARGE_THRESH_BAT0 = 80;
    USB_DENYLIST = "06cb:00f9";
  };
  services.upower.enable = true;

  # === Audio (Pipewire) ===
  services.pulseaudio.enable = false;
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

  programs.hyprlock.enable = true;


  services.fprintd.enable = true;
  security.pam.services.login.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;
  security.pam.services.hyprlock.fprintAuth = true;

security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "net.reactivated.fprint.device.enroll" && subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  services.gnome.gnome-keyring.enable = true;

  security.pam.services.greetd.enableGnomeKeyring = true;

  systemd.user.services.dms.path = [ pkgs.fprintd ];

# === Restart fprintd after sleep ===
  powerManagement.resumeCommands = ''
    ${pkgs.systemd}/bin/systemctl try-restart fprintd.service
  '';

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

  #services.desktopManager.cosmic.enable = true;
  #services.displayManager.cosmic-greeter.enable = true;

  # Hint electron apps (like VS Code, Discord, etc.) to use Wayland natively
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  programs.dms-shell = {
    enable = true;
    systemd.enable = true;   # starts it automatically with your session
  };


# === Printers & Scanners ===
services.printing = {
    enable = true;
    # drivers = with pkgs; [ hplip ];   # only if your printer needs one, see below
  };

  # Network printer discovery (needed for most Wi-Fi/Ethernet printers)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

# === Development Tools ===
  programs.nix-ld.enable = true;


  # === System Packages ===
  environment.systemPackages = with pkgs; [
    git
    seahorse
    uv
  ];
}
