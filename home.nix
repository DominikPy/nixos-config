{ config, pkgs, ... }:

{
  # === User Configuration ===
  home.username = "dominik";
  home.homeDirectory = "/home/dominik";
  home.stateVersion = "26.11";

  # === Window Manager (Hyprland) ===
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      "$fileManager" = "thunar";
      "$menu" = "wofi --show drun"; 

      bind = [
        # Core Applications
        "$mod, Return, exec, $terminal"
        "$mod, E, exec, $fileManager"
        "$mod, Space, exec, $menu"
        
        # Window Management
        "$mod, Q, killactive,"
        "$mod SHIFT, M, exit,"
        "$mod, F, togglefloating,"
        "$mod, P, pseudo,"
        "$mod, J, togglesplit,"

        # Move focus
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"

        # Switch workspaces
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"

        # Move active window to a workspace
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"

        # Scroll through existing workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      bindel = [
        # Media & Brightness Controls
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      exec-once = [
        "waybar"
      ];
    };
  };

  # === Status Bar (Waybar) ===
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "battery" "tray" ];

        "hyprland/workspaces" = {
          format = "{name}";
        };
        "clock" = {
          format = "{:%H:%M  -  %b %d}";
        };
        "pulseaudio" = {
          format = "Vol: {volume}%";
          format-muted = "Muted";
          on-click = "pavucontrol"; 
        };
        "battery" = {
          format = "Bat: {capacity}%";
          format-charging = "Bat: {capacity}% (Chg)";
          states = {
            warning = 20;
            critical = 10;
          };
        };
      };
    };
    
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: sans-serif;
        font-size: 14px;
      }
      window#waybar {
        background: rgba(30, 30, 46, 0.9);
        color: #ffffff;
      }
      #workspaces button {
        padding: 0 10px;
        color: #ffffff;
      }
      #workspaces button.active {
        background: #ffffff;
        color: #000000;
      }
      #clock, #pulseaudio, #battery, #tray, #window {
        padding: 0 15px;
      }
    '';
  };

  # === User Programs ===
  programs.kitty = {
    enable = true;
    settings = {
      window_padding_width = 4;
      background_opacity = "0.95";
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.vscode.enable = true;
  
  # Required to let Home Manager manage itself
  programs.home-manager.enable = true;

  # === User Packages ===
  home.packages = with pkgs; [
    # GUI Applications
    libreoffice-fresh
    zathura
    thunar
    imv
    wofi
    pavucontrol
    
    # CLI Utilities
    wl-clipboard
    brightnessctl

    # LazyVim Dependencies
    gcc           # Required for compiling tree-sitter syntax parsers
    ripgrep       # Fast search tool for Telescope/Fzf
    fd            # Fast file finder
    lazygit       # Git UI (LazyVim integrates this natively)

    # Communication
    # Choose ONE of the following:
    discord      # The official client
    # vesktop    # The community Wayland-optimized client (Recommended for Hyprland)
  ];
}