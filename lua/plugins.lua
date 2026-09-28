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
      -- 'enter' preset: <CR> accepts. <Tab>/<S-Tab> cycle the menu, and fall
      -- back to snippet jumping / a literal Tab when no menu is open.
      keymap = {
        preset = 'enter',
        ['<Tab>'] = { 'select_next', 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'snippet_backward', 'fallback' },
      },
      completion = {
        -- Nothing is pre-selected, so <CR> only accepts once you've tabbed
        -- to an item; otherwise it inserts a normal newline.
        list = { selection = { preselect = false } },
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

  -- Popup showing available keymaps as you type a prefix (e.g. <leader>).
  -- Reads the `desc` already set on every keymap in this config.
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {},
  },

  -- Tab-like bar showing open buffers.
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        always_show_bufferline = true,
        diagnostics = 'nvim_lsp', -- shows LSP error/warning counts per buffer
        -- Keeps the bar from overlapping the nvim-tree sidebar when it's open.
        offsets = {
          { filetype = 'NvimTree', text = 'File Explorer', highlight = 'Directory', text_align = 'left' },
        },
      },
    },
  },
}
