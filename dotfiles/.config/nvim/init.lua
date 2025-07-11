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

-- Load the rest of the configuration
require('vj')

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
