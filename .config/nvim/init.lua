vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.wrap = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.g.mapleader = ' '


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "EdenEast/nightfox.nvim",
  "nvim-lualine/lualine.nvim",
  "nvim-treesitter/nvim-treesitter",
  "neovim/nvim-lspconfig",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "airblade/vim-gitgutter",
  "numToStr/Comment.nvim",
  "mfussenegger/nvim-lint",
  {"akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons"},
  {"nvim-telescope/telescope.nvim", dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
})


require('lualine').setup()

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require'cmp'
cmp.setup {
  sources = {
    { name = 'nvim_lsp' }
  },
  mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require("lspconfig").tsserver.setup{
  capabilities = capabilities
}

require("mason").setup()
require("mason-lspconfig").setup()
require("bufferline").setup{}
require('Comment').setup()

require('lint').linters_by_ft = {
  typescript = {'eslint_d'},
  typescriptreact = {'eslint_d'},
  javascriptreact = {'eslint_d'},
  javascript = {'eslint_d'}
}

vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged", "InsertLeave" }, {
  pattern = { "*.tsx", "*.ts", "*.jsx", "*.js", "*.mjs"},
  callback = function()
    require("lint").try_lint()
  end,
})

-- SET THEME
vim.cmd.colorscheme('nightfox')

-- KEY MAPPING
vim.keymap.set({'n', 'x'}, 'x', '"_x')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fp', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
