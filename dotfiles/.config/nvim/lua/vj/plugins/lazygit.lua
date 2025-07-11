return {
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'Open lazy git' },
    },
    -- Make sure lazygit is installed
    init = function()
      -- Set lazygit config directory to ensure it's writable
      vim.env.LAZYGIT_CONFIG_DIR = vim.fn.expand('~/.config/lazygit')
      -- Ensure the directory exists
      if vim.fn.isdirectory(vim.env.LAZYGIT_CONFIG_DIR) == 0 then
        vim.fn.mkdir(vim.env.LAZYGIT_CONFIG_DIR, 'p')
      end
    end,
  },
}
