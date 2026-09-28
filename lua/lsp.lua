-- Diagnostics: floating window border + sort by severity so errors surface
-- first. `source = true` labels each message with which linter reported it
-- (relevant here since Python buffers get diagnostics from both pyright and
-- ruff) — most useful inside the float, where there's room to show it.
vim.diagnostic.config({
  virtual_text = true,
  severity_sort = true,
  float = { border = 'rounded', source = true },
})

-- Buffer-local keymaps only apply once a language server actually attaches,
-- so this needs to happen on LspAttach rather than at top level.
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
  callback = function(args)
    local opts = { buffer = args.buf }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format({ async = true })
    end, opts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
    -- Full, untruncated diagnostic text for the current line, in a floating
    -- window sized to the message rather than the split's width.
    vim.keymap.set('n', '<leader>sd', vim.diagnostic.open_float, opts)
  end,
})

-- Sort Python imports with ruff on every save. This must be a synchronous
-- request: vim.lsp.buf.code_action({ apply = true }) is async, so in
-- BufWritePre the file would be written before the edits landed.
vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('PythonOrganizeImports', { clear = true }),
  pattern = '*.py',
  callback = function(args)
    local client = vim.lsp.get_clients({ bufnr = args.buf, name = 'ruff' })[1]
    if not client then
      return
    end
    local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
    params.context = { only = { 'source.organizeImports' }, diagnostics = {} }
    local res = client:request_sync('textDocument/codeAction', params, 1000, args.buf)
    if not res or res.err then
      return
    end
    for _, action in ipairs(res.result or {}) do
      -- Ruff returns actions without their edit; it has to be resolved lazily.
      if not action.edit then
        local resolved = client:request_sync('codeAction/resolve', action, 1000, args.buf)
        action = resolved and resolved.result or action
      end
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
      end
    end
  end,
})
