{ config, pkgs, ... }:

{
  home.username = "dominik";
  home.homeDirectory = "/home/dominik";
  home.stateVersion = "24.05";

  # Hyprland Configuration
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

 # Waybar Configuration
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        
        # Define which modules appear where
        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "pulseaudio" "battery" "tray" ];

        # Module Configurations
        "hyprland/workspaces" = {
          format = "{name}";
        };
        "clock" = {
          format = "{:%H:%M  -  %b %d}"; # E.g., 14:30 - Sep 28
        };
        "pulseaudio" = {
          format = "Vol: {volume}%";
          format-muted = "Muted";
          # Clicking the volume block will open your graphical audio mixer
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
    
    # Minimal CSS to make it look clean and readable
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
  # Kitty Terminal
  programs.kitty = {
    enable = true;
    settings = {
      window_padding_width = 4;
      background_opacity = "0.95";
    };
  };

  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  # Productivity & Utility Packages
  home.packages = with pkgs; [
    # Office & Documents
    libreoffice-fresh
    zathura
    
    # File Management & Media
    thunar
    imv
    wofi
    
    # Utilities
    wl-clipboard
    brightnessctl
    pavucontrol

    # LazyVim Dependencies
    gcc           # Required for compiling tree-sitter syntax parsers
    ripgrep       # Fast search tool for Telescope/Fzf
    fd            # Fast file finder
    lazygit       # Git UI (LazyVim integrates this natively)
  ];

  home.stateVersion = "26.11";
}