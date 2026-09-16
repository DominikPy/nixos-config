{ config, pkgs, ... }:

{
  home.username = "dominik";
  home.homeDirectory = "/home/dominik";
  home.stateVersion = "26.05";
  
  programs.git.enable = true;
  programs.bash = {
    enable = true;
    shellAliases = {
      btw = "echo I use nixos, BTW";
    };
  };

  # Global VM graphics variables
  home.sessionVariables = {
    WLR_RENDERER_ALLOW_SOFTWARE = "1";
    LIBGL_ALWAYS_SOFTWARE = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # Install essential desktop apps declaratively
  home.packages = with pkgs; [
    waybar
    kitty
    rofi-wayland # App launcher
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    
    # Clean, modern settings layout
    settings = {
      "$mod" = "SUPER";

      bind = [
        "$mod, Q, exec, kitty"
        "$mod, M, exit"
        "$mod, R, exec, rofi -show drun"
      ];

      exec-once = [
        "waybar"
      ];
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    plugins = with pkgs.vimPlugins; [
      nvim-lspconfig
      telescope-nvim
      plenary-nvim
    ];
  };
}
