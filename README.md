# nvim config

Personal Neovim config, built around a terminal-in-splits workflow with full
LSP support for Python, C++, and (eventually) CUDA.

## Requirements

- Neovim 0.11+ (built and tested on 0.12)
- [Homebrew](https://brew.sh) packages: `tree-sitter-cli`, `node`, `fzf`
  (`clangd` too, unless you let Mason install its own copy)
- `git` (for lazy.nvim's bootstrap clone)

```sh
brew install tree-sitter-cli node fzf
```

## Structure

```
init.lua        -- options, core keymaps, lazy.nvim bootstrap
lua/plugins.lua -- plugin specs (lazy.nvim)
lua/lsp.lua     -- diagnostics config + LSP keymaps (on LspAttach)
lua/explore.lua -- keymaps for fzf-lua / aerial / nvim-tree
```

On first launch, lazy.nvim bootstraps itself and installs all plugins.
Language servers (`pyright`, `ruff`, `clangd`) are installed automatically
by Mason — no manual setup needed beyond the Homebrew packages above.

**Reloading config**: lazy.nvim does not support `:source`-ing `init.lua`
while Neovim is running (it'll print a warning and can leave `package.loaded`
in a broken state). After editing config, quit and reopen Neovim instead.

## Leader key

`,` (comma). Note this shadows the built-in `,` motion (repeat last
`f`/`t`/`F`/`T` search in reverse).

## Keymaps

All keymaps below are documented in-editor too: press `<leader>` (or any
prefix key like `g` or `[`) and pause — which-key.nvim pops up showing every
available continuation with its description, live and always up to date.

### Window / terminal navigation

| Key | Mode | Action |
|---|---|---|
| `<C-h/j/k/l>` | normal, terminal | Move focus between splits |
| `<Esc>` | terminal | Exit terminal mode |
| `<leader>t` | normal | Open a terminal in a new horizontal split |

Terminal buffers auto-enter insert mode on focus and hide line numbers.

### Save / quit

| Key | Mode | Action |
|---|---|---|
| `<C-s>` | normal, insert | Save file |
| `:W` `:Q` `:Wq` `:WQ` `:Qa` `:QA` | command | Aliases for the lowercase equivalents (forgives shift-key typos) |

### Commenting

Uses Neovim's built-in commenting, which picks the right comment syntax per
filetype (`#` for Python, `//` for C/C++/CUDA).

| Key | Mode | Action |
|---|---|---|
| `<leader>/` | normal | Toggle comment on the current line |
| `<leader>/` | visual | Toggle comment on the selected lines |
| `gc{motion}` | normal | Built-in operator, e.g. `gcap` comments a paragraph |

### LSP (active once a server attaches to the buffer)

| Key | Action |
|---|---|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Find references |
| `gi` | Go to implementation |
| `K` | Hover docs |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>f` | Format buffer |
| `[d` / `]d` | Previous / next diagnostic |
| `<leader>sd` | Show the full diagnostic for the current line in a floating window (not truncated by narrow splits) |

### Completion (blink.cmp, insert mode)

The menu opens automatically as you type. Nothing is pre-selected, so
`<CR>` inserts a normal newline until you've tabbed to an item.

| Key | Action |
|---|---|
| `<Tab>` / `<S-Tab>` | Next / previous item (jumps snippet placeholders when no menu is open) |
| `<CR>` | Accept the selected item |
| `<C-e>` | Close the menu |
| `<C-space>` | Open the menu / toggle docs |

### Buffers

A bufferline (tab bar) is always visible at the top showing open buffers,
with per-buffer LSP diagnostic counts.

| Key | Action |
|---|---|
| `<leader>h` | Previous buffer |
| `<leader>l` | Next buffer |
| `<leader>bp` | Pick a buffer by its tab letter |
| `<leader>bd` | Close current buffer, keeping the window/split open |

### Finding things

| Key | Action |
|---|---|
| `<leader>ff` | Fuzzy-find files (fzf-lua, backed by real `fzf`) |
| `<leader>fg` | Live grep across the repo |
| `<leader>fb` | Fuzzy-find open buffers |
| `<leader>o` | Toggle symbol outline sidebar (aerial.nvim) |
| `<leader>e` | Toggle file explorer sidebar (nvim-tree) |

## Language support

- **Python**: `pyright` (types) + `ruff` (lint/format) via Mason. Saving a
  `.py` file sorts its imports through ruff's "Organize imports" action (see
  `lua/lsp.lua`); this happens even in projects that don't enable ruff's `I`
  rules. It does not run the formatter — use `<leader>f` for that.
- **C++**: `clangd`. Needs a `compile_commands.json` for real accuracy:
  - CMake: `cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -B build && ln -s build/compile_commands.json .`
  - Makefile: `brew install bear && bear -- make`
- **CUDA**: same `clangd`, same mechanism — `.cu` is already in clangd's
  default filetypes and treesitter's parser list. No extra config needed;
  just requires a machine with the CUDA toolkit for real semantic support
  (Apple Silicon Macs can't run it locally).
