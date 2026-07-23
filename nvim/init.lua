vim.o.clipboard = 'unnamedplus'
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank()
    end,
})

vim.o.guicursor = "n-v-c:ver25,i:ver25-blinkwait250-blinkon250-blinkoff250,r:block"

vim.o.number = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.scrolloff = 10
vim.o.list = true
vim.o.confirm = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4

vim.o.swapfile = false
vim.o.undofile = true

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.cmd('packadd! nohlsearch')

vim.pack.add({
    'https://github.com/ellisonleao/gruvbox.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons',
    'https://github.com/nvim-lualine/lualine.nvim',
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/folke/lazydev.nvim',
    'https://github.com/lewis6991/gitsigns.nvim',
})

require("gruvbox").setup()
vim.cmd.colorscheme("gruvbox")
require('gitsigns').setup()
require("lualine").setup()

require("lazydev").setup()
vim.lsp.enable('clangd')
vim.lsp.enable('lua_ls')

vim.diagnostic.config({
    virtual_text = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "󱈸",
            [vim.diagnostic.severity.HINT] = "󰌵",
            [vim.diagnostic.severity.INFO] = "i",
        },
    },
    update_in_insert = true,
    severity_sort = true,
    float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
    },
})


vim.g.mapleader = " "

vim.keymap.set("n", "<leader>d", function()
  vim.diagnostic.open_float({ scope = "line", focus = false })
end)
vim.keymap.set("n", "<leader>a", vim.lsp.buf.code_action)

vim.o.completeopt = "menuone,noselect,popup"
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, {
        autotrigger = true,
      })
    end
  end,
})

vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get)

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.lua",
  callback = function(args)
      vim.cmd("silent keepjumps %!stylua --stdin-filepath " ..
      vim.fn.shellescape(args.file) .. " -")
  end,
})

