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
      -- The 'hl' object is automatically injected globally by Hyprland.
      
      local mod = "SUPER"
      local terminal = "kitty"
      local fileManager = "thunar"
      local menu = "wofi --show drun"

      hl.config({
        ["exec-once"] = { "waybar" }
      })

      -- Core Applications
      hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
      hl.bind(mod .. " + E", hl.dsp.exec_cmd(fileManager))
      hl.bind(mod .. " + Space", hl.dsp.exec_cmd(menu))
      
      -- Window Management
      -- We use hyprctl dispatch via exec_cmd as a foolproof fallback for some window binds
      hl.bind(mod .. " + Q", hl.dsp.exec_cmd("hyprctl dispatch killactive"))
      hl.bind(mod .. " + SHIFT + M", hl.dsp.exec_cmd("hyprctl dispatch exit"))
      hl.bind(mod .. " + F", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mod .. " + P", hl.dsp.window.pseudo())
      hl.bind(mod .. " + J", hl.dsp.layout("togglesplit"))

      -- Move focus
      hl.bind(mod .. " + left", hl.dsp.focus({ direction = "l" }))
      hl.bind(mod .. " + right", hl.dsp.focus({ direction = "r" }))
      hl.bind(mod .. " + up", hl.dsp.focus({ direction = "u" }))
      hl.bind(mod .. " + down", hl.dsp.focus({ direction = "d" }))

      -- Switch workspaces & Move windows
      for i = 1, 5 do
        hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = i }))
        hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
      end

      -- Scroll through existing workspaces
      hl.bind(mod .. " + mouse_down", hl.dsp.exec_cmd("hyprctl dispatch workspace e+1"))
      hl.bind(mod .. " + mouse_up", hl.dsp.exec_cmd("hyprctl dispatch workspace e-1"))

      -- Mouse binds (Move and Resize)
      -- The old bindm is replaced by adding { mouse = true }
      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- Media Controls
      -- The old bindel is replaced by adding { repeating = true, locked = true }
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true, locked = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true, locked = true })
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
      hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl s 10%+"), { repeating = true, locked = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { repeating = true, locked = true })
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