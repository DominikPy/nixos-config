{ config, pkgs, ... }:

{
  # === User Configuration ===
  home.username = "dominik";
  home.homeDirectory = "/home/dominik";
  home.stateVersion = "26.11";

  # === Window Manager (Hyprland) ===
wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      local hl = require("hyprland")
      
      local mod = "SUPER"
      local terminal = "kitty"
      local fileManager = "thunar"
      local menu = "wofi --show drun"

      hl.config({
        exec_once = { "waybar" }
      })

      -- Core Applications
      hl.bind(mod, "Return", "exec", terminal)
      hl.bind(mod, "E", "exec", fileManager)
      hl.bind(mod, "Space", "exec", menu)
      
      -- Window Management
      hl.bind(mod, "Q", "killactive")
      hl.bind(mod .. " SHIFT", "M", "exit")
      hl.bind(mod, "F", "togglefloating")
      hl.bind(mod, "P", "pseudo")
      hl.bind(mod, "J", "togglesplit")

      -- Move focus
      hl.bind(mod, "left", "movefocus", "l")
      hl.bind(mod, "right", "movefocus", "r")
      hl.bind(mod, "up", "movefocus", "u")
      hl.bind(mod, "down", "movefocus", "d")

      -- Switch workspaces
      hl.bind(mod, "1", "workspace", "1")
      hl.bind(mod, "2", "workspace", "2")
      hl.bind(mod, "3", "workspace", "3")
      hl.bind(mod, "4", "workspace", "4")
      hl.bind(mod, "5", "workspace", "5")

      -- Move active window to a workspace
      hl.bind(mod .. " SHIFT", "1", "movetoworkspace", "1")
      hl.bind(mod .. " SHIFT", "2", "movetoworkspace", "2")
      hl.bind(mod .. " SHIFT", "3", "movetoworkspace", "3")
      hl.bind(mod .. " SHIFT", "4", "movetoworkspace", "4")
      hl.bind(mod .. " SHIFT", "5", "movetoworkspace", "5")

      -- Scroll through existing workspaces
      hl.bind(mod, "mouse_down", "workspace", "e+1")
      hl.bind(mod, "mouse_up", "workspace", "e-1")

      -- Mouse binds (Move and Resize)
      hl.bindm(mod, "mouse:272", "movewindow")
      hl.bindm(mod, "mouse:273", "resizewindow")

      -- Media & Brightness Controls (Execute while locked & allow repeating)
      hl.bindel("", "XF86AudioRaiseVolume", "exec", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")
      hl.bindel("", "XF86AudioLowerVolume", "exec", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")
      hl.bindel("", "XF86AudioMute", "exec", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")
      hl.bindel("", "XF86AudioMicMute", "exec", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")
      hl.bindel("", "XF86MonBrightnessUp", "exec", "brightnessctl s 10%+")
      hl.bindel("", "XF86MonBrightnessDown", "exec", "brightnessctl s 10%-")
    '';
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