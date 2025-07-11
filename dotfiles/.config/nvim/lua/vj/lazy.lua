-- Use a writable data directory
local data_dir = vim.fn.expand('~/.local/share/nvim_data')
local lazypath = data_dir .. '/lazy/lazy.nvim'

if not vim.loop.fs_stat(lazypath) then
  -- Create the directory if it doesn't exist
  vim.fn.mkdir(vim.fn.fnamemodify(lazypath, ':h'), 'p')
  
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({ { import = 'vj.plugins' } }, {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
  -- Use a custom lockfile path that is writable
  lockfile = data_dir .. '/lazy-lock.json',
  -- Use a custom state directory that is writable
  state = data_dir .. '/lazy/state.json',
  -- Use a custom cache directory that is writable
  cache = {
    enabled = true,
    path = vim.fn.expand('~/.cache/nvim_cache/lazy/cache'),
  },
})
