# NixOS ThinkPad T14 Deployment Guide

This guide assumes the `nixos-config` folder has already been transferred to the physical ThinkPad (Step 1).

## Step 2: Adapt Configuration for Physical Hardware

Before building the system on bare metal, you must replace the VirtualBox hardware profile and remove the VM-specific workarounds.

1. **Navigate to your configuration folder:**
   ```bash
   cd ~/nixos-config
   ```

2. **Generate the real hardware configuration:**
   Delete the virtualized hardware file and generate a new one specifically for your ThinkPad's components.
   ```bash
   rm hardware-configuration.nix
   nixos-generate-config --show-hardware-config > hardware-configuration.nix
   ```
   *(Note: If installing from a Live USB onto a blank drive, partition/mount your drives to `/mnt` first, then run `nixos-generate-config --root /mnt --dir ~/nixos-config` instead).*

3. **Restore the UEFI bootloader (`configuration.nix`):**
   Open `configuration.nix` and replace the legacy GRUB settings with the `systemd-boot` settings required for modern hardware:
   ```nix
   # Remove or comment out these GRUB lines:
   # boot.loader.grub.enable = true;
   # boot.loader.grub.device = "/dev/sda"; 
   # boot.loader.grub.useOSProber = false;

   # Add these lines back:
   boot.loader.systemd-boot.enable = true;
   boot.loader.efi.canTouchEfiVariables = true;
   ```

4. **Remove software rendering (`configuration.nix`):**
   Find and delete the entire `environment.sessionVariables` block that contains `WLR_RENDERER_ALLOW_SOFTWARE = "1"`. Your physical Intel GPU natively supports Wayland and hardware acceleration.

## Step 3: Track Changes and Build the System

Nix Flakes strictly require all files to be tracked by Git. Since you created a new `hardware-configuration.nix`, it must be staged before building.

1. **Stage all files:**
   ```bash
   git add .
   ```

2. **Build and switch to the new configuration:**
   ```bash
   sudo nixos-rebuild switch --flake .#thinkpad
   ```

## Step 4: Post-Installation Setup

Once the system is built, reboot. You will be greeted by the `tuigreet` terminal login. Log in, and you will drop straight into Hyprland. 

1. **Enroll your fingerprint:**
   Open Kitty (`Super + Enter`) and run the enrollment process:
   ```bash
   fprintd-enroll
   ```
   Swipe your finger on the sensor when prompted. You can now use your fingerprint for `sudo` commands and future logins.

2. **Bootstrap LazyVim:**
   The required system dependencies (`gcc`, `ripgrep`, `fd`, `lazygit`) were already installed via `home.nix` during the system build. To install the Neovim environment, run:
   ```bash
   git clone [https://github.com/LazyVim/starter](https://github.com/LazyVim/starter) ~/.config/nvim
   rm -rf ~/.config/nvim/.git
   ```
   Type `nvim` in your terminal to launch the editor. LazyVim will automatically download and configure all plugins on the first run.