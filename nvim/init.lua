vim.g.mapleader = " "

-- options
vim.o.clipboard = "unnamedplus"
vim.o.confirm = true

vim.o.number = true
vim.o.relativenumber = true
vim.o.scrolloff = 10
vim.o.list = true

vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.tabstop = 2

vim.o.swapfile = false
vim.o.undofile = true

vim.o.completeopt = "menuone,noselect,popup"

-- plugins
vim.cmd("packadd! nohlsearch")

vim.pack.add({
  "https://github.com/ellisonleao/gruvbox.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/nvim-treesitter/nvim-treesitter",
  "https://github.com/nvim-treesitter/nvim-treesitter-context",
  "https://github.com/karb94/neoscroll.nvim",
  "https://github.com/ibhagwan/fzf-lua",
})

vim.cmd.colorscheme("gruvbox")
require("gitsigns").setup()
require("lazydev").setup()
require("lualine").setup({ sections = { lualine_x = { "filetype" } } })
require("nvim-treesitter").install({ "cpp" })
require("neoscroll").setup()
local fzf = require("fzf-lua")
fzf.setup()

-- lsp
vim.lsp.config("neocmake", {
  init_options = {
    format = { enable = true },
    lint = { enable = true }
  }
})

vim.lsp.enable({ "clangd", "lua_ls", "neocmake" })

vim.diagnostic.config({ virtual_text = true })

-- keymaps
vim.keymap.set("n", "<leader>h", function()
  vim.cmd.LspClangdSwitchSourceHeader()
end, {
  desc = "switch source/header"
})

vim.keymap.set("n", "<leader>f", fzf.files, {
  desc = "find files"
})

vim.keymap.set("n", "<leader>b", fzf.buffers, {
  desc = "find buffers"
})

vim.keymap.set("n", "<leader>g", fzf.live_grep, {
  desc = "search project"
})

vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get, {
  desc = "trigger completion"
})

-- autocmds
local config_group = vim.api.nvim_create_augroup("config", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = config_group,
  desc = "highlight yanked text",
  callback = function()
    vim.hl.on_yank()
  end
})

vim.api.nvim_create_autocmd("FileType", {
  group = config_group,
  desc = "disable comment continuation",
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end
})

vim.api.nvim_create_autocmd("FileType", {
  group = config_group,
  pattern = { "c", "cpp" },
  desc = "enable treesitter highlighting",
  callback = function()
    vim.treesitter.start()
  end
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = config_group,
  desc = "configure LSP features",
  callback = function(event)
    local client = assert(vim.lsp.get_client_by_id(event.data.client_id))

    if client:supports_method("textDocument/completion") then
      local chars = {}
      for i = 32, 126 do
        table.insert(chars, string.char(i))
      end
      client.server_capabilities.completionProvider.triggerCharacters = chars

      vim.lsp.completion.enable(true, client.id, event.buf, {
        autotrigger = true
      })
    end

    if
        not client:supports_method("textDocument/willSaveWaitUntil")
        and client:supports_method("textDocument/formatting")
    then
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = config_group,
        buffer = event.buf,
        desc = "format with LSP",
        callback = function()
          vim.lsp.buf.format({ bufnr = event.buf, id = client.id })
        end
      })
    end
  end
})
