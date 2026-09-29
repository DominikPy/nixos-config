	{ config, pkgs, ... }:

{
  # === User Configuration ===
  home.username = "dominik";
  home.homeDirectory = "/home/dominik";
  home.stateVersion = "26.11";

  # === Lock Screen & Idle Daemon ===
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";       
        before_sleep_cmd = "loginctl lock-session";  
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
    };
  };

# === Wallpaper (Hyprpaper) ===
  services.hyprpaper = {
  enable = true;
  settings = {
    splash = false;
    wallpaper = [
      {
        monitor = "";
        path = "${./img/aqua.jpg}";
        fit_mode = "cover";
      }
    ];
  };
};

# === Lock Screen UI & Fingerprint ===
  programs.hyprlock = {
    enable = true;
    settings = {
      auth = {
        fingerprint = {
          enabled = true;
          ready_message = "Scan fingerprint to unlock";
          present_message = "Scanning...";
        };
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 2;
          blur_size = 5;
        }
      ];

      input-field = [
        {
          size = "250, 50";
          position = "0, -80";
          dots_center = true;
          fade_on_empty = false;
          placeholder_text = "Password or Fingerprint...";
        }
      ];

      label = [
        {
          text = "$TIME";
          font_size = 64;
          position = "0, 80";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };

  # === Window Manager (Hyprland) ===
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    extraConfig = ''
      local mod         = "SUPER"
      local terminal    = "kitty"
      local fileManager = "thunar"
      local menu        = "wofi --show drun"

      -- Keyboard layouts: US and Czech QWERTY
      hl.config({
        input = {
          kb_layout  = "us,cz",
          kb_variant = ",qwerty",
          touchpad = {
            natural_scroll = true,
          },
        },
      })

      -- Core applications
      hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
      hl.bind(mod .. " + E",      hl.dsp.exec_cmd(fileManager))
      hl.bind(mod .. " + D",      hl.dsp.exec_cmd(menu))

      -- Switch keyboard layout (like Win + Space)
      hl.bind(mod .. " + Space", hl.dsp.exec_cmd("hyprctl switchxkblayout all next"))

      -- Window management
      hl.bind(mod .. " + Q",         hl.dsp.window.close())
      hl.bind(mod .. " + SHIFT + M", hl.dsp.exit())
      hl.bind(mod .. " + F",         hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mod .. " + P",         hl.dsp.window.pseudo())
      hl.bind(mod .. " + J",         hl.dsp.layout("togglesplit"))

      -- Move focus
      hl.bind(mod .. " + left",  hl.dsp.focus({ direction = "left" }))
      hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
      hl.bind(mod .. " + up",    hl.dsp.focus({ direction = "up" }))
      hl.bind(mod .. " + down",  hl.dsp.focus({ direction = "down" }))

      -- Workspaces 1-5: switch, and move window
      for i = 1, 5 do
        hl.bind(mod .. " + " .. i,         hl.dsp.focus({ workspace = i }))
        hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
      end

      -- Scroll through workspaces
      hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
      hl.bind(mod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

      -- Mouse move/resize
      hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
      hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

      -- Power profiles (TLP)
      hl.bind(mod .. " + F10", hl.dsp.exec_cmd("tlpctl power-saver"))
      hl.bind(mod .. " + F11", hl.dsp.exec_cmd("tlpctl balanced"))
      hl.bind(mod .. " + F12", hl.dsp.exec_cmd("tlpctl performance"))

      -- Media & brightness
      hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
      hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
      hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })
    '';
  };

  # === Status Bar (Waybar) ===
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

# === Waybar Clock ===
        clock = {
          format = "{:%H:%M - %b %d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    };

        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "hyprland/language" "custom/power" "pulseaudio" "battery" "tray" ];

        "hyprland/workspaces" = {
          format = "{name}";
        };
        "hyprland/language" = {
          format = "{short}";
        };
        # TLP profile: shows current profile, click cycles
        # power-saver -> balanced -> performance
        "custom/power" = {
          exec = "tlpctl get";
          interval = 10;
          signal = 8;
          format = "Pwr: {}";
          on-click = "sh -c 'case $(tlpctl get) in power-saver) tlpctl balanced;; balanced) tlpctl performance;; *) tlpctl power-saver;; esac; pkill -RTMIN+8 waybar'";
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
      #clock, #pulseaudio, #battery, #tray, #window, #custom-power, #language {
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

    programs.git = {
    enable = true;
    settings = {
      user.name = "Dominik Novotny";
      user.email = "medunadominik@gmail.com";
      init.defaultBranch = "main";
    };
  };

    programs.vscode = {
  enable = true;
  argvSettings."password-store" = "gnome-libsecret";
};

  # Required to let Home Manager manage itself
  programs.home-manager.enable = true;

  # === User Packages ===
  home.packages = with pkgs; [
    # GUI Applications
    libreoffice
    zathura
    thunar
    imv
    wofi
    pavucontrol
    firefox

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
