-- Fuzzy file finder (fzf-lua)
vim.keymap.set('n', '<leader>ff', function() require('fzf-lua').files() end, { desc = 'Find files' })
vim.keymap.set('n', '<leader>fg', function() require('fzf-lua').live_grep() end, { desc = 'Grep in repo' })
vim.keymap.set('n', '<leader>fb', function() require('fzf-lua').buffers() end, { desc = 'Find open buffers' })

-- Symbol outline sidebar (aerial.nvim)
vim.keymap.set('n', '<leader>o', '<cmd>AerialToggle<CR>', { desc = 'Toggle symbol outline' })

-- File explorer sidebar (nvim-tree)
vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
