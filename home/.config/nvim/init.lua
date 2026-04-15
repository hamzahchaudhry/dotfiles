-- colorscheme
vim.cmd('colorscheme habamax')


-- providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0


-- options
vim.o.number = true
vim.o.relativenumber = true
vim.o.modeline = false

vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.list = true
vim.o.confirm = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.autoindent = true

vim.cmd('filetype plugin indent on')


-- diagnostics
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
})


-- autocommands
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})


-- keymaps
vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
vim.keymap.set('n', 'gr', vim.lsp.buf.references)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)


-- plugins
vim.cmd('packadd! nohlsearch')

vim.pack.add({
  -- lsp
  'https://github.com/neovim/nvim-lspconfig',
  -- fuzzy finder
  'https://github.com/ibhagwan/fzf-lua',
  -- completion
  'https://github.com/nvim-mini/mini.completion',
  -- quickfix
  'https://github.com/stevearc/quicker.nvim',
  -- git
  'https://github.com/lewis6991/gitsigns.nvim',
})


-- plugin setup
require('fzf-lua').setup { fzf_colors = true }
require('mini.completion').setup {}
require('quicker').setup {}
require('gitsigns').setup {}


-- lsp
vim.lsp.enable('clangd')
vim.lsp.enable('pyright')
