-- <leader> is expanded when each mapping is defined, so this must come before
-- every <leader> keymap in this file and before any plugin spec runs.
vim.g.mapleader = ','

-- Hybrid line numbers: absolute on the current line, relative elsewhere.
-- Terminal buffers opt out of this below, in the TermOpen autocmd.
vim.opt.number = true
vim.opt.relativenumber = true

-- Exit terminal mode easily
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { desc = 'Exit terminal mode' })

-- Navigate between windows with Ctrl+hjkl, from both normal mode and
-- terminal mode. This is the main fix: without the terminal-mode mappings,
-- you'd have to hit <Esc> first just to move focus out of a terminal split.
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to window below' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to window above' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })

vim.keymap.set('t', '<C-h>', [[<C-\><C-n><C-w>h]], { desc = 'Go to left window' })
vim.keymap.set('t', '<C-j>', [[<C-\><C-n><C-w>j]], { desc = 'Go to window below' })
vim.keymap.set('t', '<C-k>', [[<C-\><C-n><C-w>k]], { desc = 'Go to window above' })
vim.keymap.set('t', '<C-l>', [[<C-\><C-n><C-w>l]], { desc = 'Go to right window' })

-- Terminal buffers are only useful in insert mode, so drop straight into it
-- whenever you focus one, and don't clutter them with line numbers/signcolumn.
-- Grouped with clear = true so re-sourcing this file doesn't stack duplicate
-- autocmds (keymaps are naturally idempotent, but autocmds aren't).
local term_group = vim.api.nvim_create_augroup('TerminalSetup', { clear = true })

vim.api.nvim_create_autocmd('TermOpen', {
  group = term_group,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.signcolumn = 'no'
    vim.cmd('startinsert')
  end,
})
vim.api.nvim_create_autocmd('BufEnter', {
  group = term_group,
  pattern = 'term://*',
  callback = function()
    vim.cmd('startinsert')
  end,
})

-- Quick toggle for a terminal split
vim.keymap.set('n', '<leader>t', ':split | terminal<CR>', { desc = 'Open terminal in horizontal split' })

-- Forgive shift-key typos on save/quit commands. Using real user commands
-- instead of cnoreabbrev avoids accidental substitution elsewhere on the
-- command line (e.g. typing W as part of a filename or range).
vim.api.nvim_create_user_command('W', 'w', { bang = true })
vim.api.nvim_create_user_command('Q', 'q', { bang = true })
vim.api.nvim_create_user_command('Wq', 'wq', { bang = true })
vim.api.nvim_create_user_command('WQ', 'wq', { bang = true })
vim.api.nvim_create_user_command('Qa', 'qa', { bang = true })
vim.api.nvim_create_user_command('QA', 'qa', { bang = true })

-- Save with Ctrl+S from normal and insert mode, like most other editors.
vim.keymap.set('n', '<C-s>', ':w<CR>', { desc = 'Save file' })
vim.keymap.set('i', '<C-s>', '<Esc>:w<CR>', { desc = 'Save file' })

-- Toggle comments. Neovim's built-in `gc` operator does the work; the
-- mappings must remap (remap = true) because gc/gcc are themselves mappings.
vim.keymap.set('n', '<leader>/', 'gcc', { remap = true, desc = 'Toggle comment' })
vim.keymap.set('v', '<leader>/', 'gc', { remap = true, desc = 'Toggle comment' })

-- nvim-tree replaces the built-in netrw explorer; disable netrw first to
-- avoid the two fighting over directory buffers.
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Bootstrap lazy.nvim: clone it on first run, then prepend to runtimepath.
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    'git', 'clone', '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup(require('plugins'))
require('lsp')
require('explore')
require('buffers')
