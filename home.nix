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

catppuccin = {
	enable = true;
	flavor = "mocha";
	autoEnable = true;
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
    rofi
    ripgrep
    nil
  ];

wayland.windowManager.hyprland = {
  enable = true;

  extraConfig = ''
    local mod = "SUPER"

    -- Launchers & Applications
    hl.bind(mod .. " + Return", hl.dsp.exec_cmd("kitty"))
    hl.bind(mod .. " + Space", hl.dsp.exec_cmd("rofi -show drun"))
    hl.bind(mod .. " + E", hl.dsp.exec_cmd("kitty -e yazi"))
    hl.bind(mod .. " + L", hl.dsp.exec_cmd("loginctl lock-session"))

    -- Window Management
    hl.bind(mod .. " + Q", hl.dsp.window.close())
    hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
    hl.bind(mod .. " + V", hl.dsp.window.float({ action = "toggle" }))
    hl.bind(mod .. " + M", hl.dsp.window.fullscreen({ mode = 1 }))

    -- Focus movement
    hl.bind(mod .. " + Left", hl.dsp.focus({ direction = "left" }))
    hl.bind(mod .. " + Right", hl.dsp.focus({ direction = "right" }))
    hl.bind(mod .. " + Up", hl.dsp.focus({ direction = "up" }))
    hl.bind(mod .. " + Down", hl.dsp.focus({ direction = "down" }))

    -- Workspaces 1-9
    for i = 1, 9 do
        hl.bind(mod .. " + " .. i, hl.dsp.focus({ workspace = tostring(i) }))
        hl.bind(mod .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = tostring(i) }))
    end

    -- Startup commands
    hl.on("hyprland.start", function()
        hl.exec_cmd("waybar")
    end)
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
    which-key-nvim
    nvim-treesitter.withAllGrammars
  ];

  initLua = ''
    -- Auto-indenting and Tab settings
    vim.opt.expandtab = true
    vim.opt.shiftwidth = 2
    vim.opt.tabstop = 2
    vim.opt.smartindent = true

    -- Enable syntax warnings and LSP features for Nix
    require('lspconfig').nil_ls.setup({})
    
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
    })

    -- Your existing Telescope and Which-key setup
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
  
    require("which-key").setup()
  '';
};

}
