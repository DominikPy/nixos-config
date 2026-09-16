{ config, pkgs, ...}:

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

home.sessionVariables = {
	WLR_RENDERER_ALLOW_SOFTWARE = "1";
    	LIBGL_ALWAYS_SOFTWARE = "1";
    	WLR_NO_HARDWARE_CURSORS = "1";
};

	wayland.windowManager.hyprland = {
	enable = true;
	
		extraConfig = ''
		dofile("/home/dominik/.config/hypr/custom.lua")
		'';
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
