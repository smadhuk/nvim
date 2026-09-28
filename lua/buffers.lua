-- Cycle buffers, matching muscle memory from another config.
-- Uses bufferline's cycle commands so movement follows visual tab order,
-- not raw buffer number order.
vim.keymap.set('n', '<leader>h', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>l', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })

-- Jump straight to a buffer by its tab letter (bufferline highlights each
-- tab with a pick letter while this is active).
vim.keymap.set('n', '<leader>bp', '<cmd>BufferLinePick<CR>', { desc = 'Pick buffer' })

-- Close the current buffer without closing its window/split — plain :bdelete
-- kills the window too if it's the last buffer shown there. This switches
-- the window to another buffer first, then deletes the old one.
vim.keymap.set('n', '<leader>bd', function()
  local buf_to_close = vim.api.nvim_get_current_buf()
  local alt_buf = vim.fn.bufnr('#')
  if alt_buf ~= -1 and alt_buf ~= buf_to_close and vim.fn.buflisted(alt_buf) == 1 then
    vim.cmd('buffer #')
  else
    vim.cmd('bnext')
  end
  if vim.api.nvim_buf_is_valid(buf_to_close) then
    vim.cmd('bdelete ' .. buf_to_close)
  end
end, { desc = 'Close buffer (keep window)' })
