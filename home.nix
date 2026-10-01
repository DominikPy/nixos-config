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
      local menu        = "dms ipc call spotlight toggle"


      -- Keyboard layouts: US and Czech QWERTY
      hl.config({
        input = {
          kb_layout  = "us,cz",
          kb_variant = ",qwerty",
          accel_profile = "flat",
          sensitivity   = 0.2,
          touchpad = {
            natural_scroll = true,
          },
        },
      })
      -- Laptop panel
      hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x0", scale = 1 })

      -- Any other screen (projector): mirror the laptop
      hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1, mirror = "eDP-1" })
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

      -- Workspaces 1-9: switch, and move window
      for i = 1, 9 do
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

      -- DMS
      hl.bind(mod .. " + V",     hl.dsp.exec_cmd("dms ipc call clipboard toggle"))
      hl.bind(mod .. " + N",     hl.dsp.exec_cmd("dms ipc call notifications toggle"))
      hl.bind(mod .. " + comma", hl.dsp.exec_cmd("dms ipc call settings focusOrToggle"))

      -- 3-finger swipe left/right: switch workspace (like GNOME)
      hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

      -- 3-finger swipe up: open the launcher (stand-in for GNOME's overview)
      hl.gesture({
        fingers = 3,
        direction = "up",
        action = function() hl.exec_cmd("dms ipc call spotlight toggle") end,
      })

      -- Screen capture
      -- Screenshots
      hl.bind("Print", hl.dsp.exec_cmd("dms screenshot"))
      hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

      -- Media & brightness
      hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
      hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
      hl.bind("XF86AudioMicMute",      hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s 10%+"), { locked = true, repeating = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { locked = true, repeating = true })
    
    -- Window appearance
      hl.config({
        decoration = {
          rounding = 12,
        },
      })

    -- Miscellaneous
      hl.config({
        misc = {
          focus_on_activate = true,
        },
      })
    '';
  };
/*
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
*/
  # === User Programs ===
  programs.kitty = {
    enable = true;
    themeFile = "Catppuccin-Mocha";
    settings = {
      window_padding_width = 4;
      background_opacity = "0.95";
      remember_window_size = "no";
    # Mauve accent
      cursor                = "#cba6f7";
      cursor_text_color     = "#1e1e2e";
      url_color             = "#cba6f7";
      active_border_color   = "#cba6f7";
      active_tab_background = "#cba6f7";
      active_tab_foreground = "#11111b";
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

   gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
  };

    programs.vscode = {
  enable = true;
  argvSettings."password-store" = "gnome-libsecret";
};

  programs.lazyvim.enable = true;

# USB Drive Management
services.udiskie = {
    enable = true;
    automount = true;
    notify = true;
    tray = "auto";
  };

  # Required to let Home Manager manage itself
  programs.home-manager.enable = true;

  # === User Packages ===
  home.packages = with pkgs; [
    # GUI Applications
    libreoffice
    zathura
    imv
    # wofi
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
    discord      # The official client
    # vesktop    # The community Wayland-optimized client (Recommended for Hyprland)

    # Development
    texliveFull
  ];
}
