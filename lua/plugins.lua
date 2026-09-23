return {
  -- LSP servers themselves are installed/managed by Mason.
  {
    'mason-org/mason.nvim',
    opts = {},
  },
  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = { 'neovim/nvim-lspconfig' },
    opts = {
      ensure_installed = { 'pyright', 'ruff', 'clangd' },
      automatic_enable = true, -- calls vim.lsp.enable() for each installed server
    },
  },
  { 'neovim/nvim-lspconfig' },

  -- Completion popup wired into the built-in LSP client.
  {
    'saghen/blink.cmp',
    version = '*',
    opts = {
      keymap = { preset = 'default' }, -- <C-y> confirm, <C-n>/<C-p> select, <C-space> open docs
      completion = {
        documentation = { auto_show = true },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
      },
    },
  },

  -- Better highlighting/parsing for Python, C++, CUDA, etc.
  -- Pinned to the 'main' branch's newer API: parser install and highlighting
  -- are separate steps now (no more configs.setup()).
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    config = function()
      local langs = { 'python', 'cpp', 'c', 'cuda', 'lua', 'vim', 'vimdoc', 'bash' }
      require('nvim-treesitter').install(langs)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = langs,
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },

  { 'nvim-tree/nvim-web-devicons', opts = {} },

  -- Fuzzy file finder (wraps the real fzf binary), plus grep/buffers for free.
  {
    'ibhagwan/fzf-lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },

  -- Symbol outline sidebar (functions/classes/etc. in the current file).
  {
    'stevearc/aerial.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },

  -- File explorer sidebar.
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {},
  },
}
