{
  config,
  pkgs,
  inputs,
  lib,
  system ? "x86_64-linux",
  ...
}: {
  imports = [
    inputs.nvchad4nix.homeManagerModule
  ];
  
  programs.nvchad = {
    enable = true;
    # Use the nvchad from the nvchad4nix package
    nvchad = inputs.nvchad4nix.packages.${pkgs.system}.nvchad;
    neovim = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    extraPackages = with pkgs; [
      nodePackages.bash-language-server 
      nodePackages.prettier
      nodePackages.typescript-language-server
      nixfmt-rfc-style
      rustfmt
      shfmt
      emmet-language-server
      nixd
      vscode-langservers-extracted
      vue-language-server
      (python3.withPackages(ps: with ps; [
        python-lsp-server
        python-lsp-ruff
        flake8
      ]))
    ];
    # Use the nvchad-on-steroids directory instead of nvim
    extraConfig = ../dotfiles/.config/nvchad-on-steroids;
    hm-activation = true;
    backup = false;
  };

  # Create a custom init.lua that loads the vj module correctly
  home.file.".config/nvim/init.lua".text = ''
    -- Set data directory to a writable location
    local data_dir = vim.fn.expand('~/.local/share/nvim_data')
    local state_dir = vim.fn.expand('~/.local/state/nvim_state')
    local cache_dir = vim.fn.expand('~/.cache/nvim_cache')
    
    -- Create directories if they don't exist
    for _, dir in ipairs({ data_dir, state_dir, cache_dir }) do
      if vim.fn.isdirectory(dir) == 0 then
        vim.fn.mkdir(dir, 'p')
      end
    end
    
    -- Set Neovim directories to writable locations
    vim.opt.runtimepath:prepend(data_dir)
    vim.env.XDG_DATA_HOME = data_dir
    vim.env.XDG_STATE_HOME = state_dir
    vim.env.XDG_CACHE_HOME = cache_dir
    
    -- Ensure lazy.nvim uses the writable data directory for its lock file
    vim.g.lazy_lock_file = data_dir .. '/lazy-lock.json'
    
    -- Add the custom lua directory to the runtimepath
    local custom_lua_dir = vim.fn.stdpath('config') .. '/lua'
    vim.opt.runtimepath:prepend(custom_lua_dir)
    
    -- Load the NVChad configuration
    require('nvchad')
    
    --[[
    =====================================================================
    ==================== Thank You TJ for Kickstart =====================
    =====================================================================
    ========                                    .-----.          ========
    ========         .----------------------.   | === |          ========
    ========         |.-""""""""""""""""""-.|   |-----|          ========
    ========         ||                    ||   | === |          ========
    ========         ||    MYCONFIG.NVIM   ||   |-----|          ========
    ========         ||                    ||   | === |          ========
    ========         ||                    ||   |-----|          ========
    ========         ||:VimBeGood          ||   |:::::|          ========
    ========         |'-..................-'|   |____o|          ========
    ========         `"")----------------(""`   ___________      ========
    ========        /::::::::::|  |::::::::::\  \ no mouse \     ========
    ========       /:::========|  |==hjkl==:::\  \ required \    ========
    ========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
    ========                                                     ========
    =====================================================================
    =====================================================================
    --]]
    
    -- The line beneath this is called `modeline`. See `:help modeline`
    -- vim: ts=2 sts=2 sw=2 et
  '';
}