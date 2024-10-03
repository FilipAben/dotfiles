vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.ignorecase = true
vim.opt.wrap = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.clipboard = 'unnamedplus'
vim.opt.cursorline = true
vim.opt.splitright = true
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldtext = ""
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.g.mapleader = ' '
vim.g.mkdp_auto_close = 0
vim.g.marked_filetypes = {"markdown"}

-- Lazy vim config
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

-- Packages
require("lazy").setup({
  "EdenEast/nightfox.nvim",
  "nvim-lualine/lualine.nvim",
  "nvim-treesitter/nvim-treesitter",
  "neovim/nvim-lspconfig",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "lewis6991/gitsigns.nvim",
  "numToStr/Comment.nvim",
  "mfussenegger/nvim-lint",
  "mhartington/formatter.nvim",
  "windwp/nvim-autopairs",
  "sindrets/diffview.nvim",
  "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
  {"akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons"},
  {"ibhagwan/fzf-lua", dependencies = { "nvim-tree/nvim-web-devicons" }},
  {"ggandor/leap.nvim"},
  {"MeanderingProgrammer/markdown.nvim", name = "render-markdown", dependencies = { "nvim-treesitter/nvim-treesitter" }},

  -- LSP
  { 'mrcjkb/rustaceanvim', lazy = false }
})

-- Package configs
require('nvim-treesitter.configs').setup({
  ensure_installed = { "ruby", "embedded_template", "rust", "markdown", "markdown_inline", "typescript", "javascript" },
  auto_install = true,
  highlight = {
    enable = true,
  },
})

require("fzf-lua").setup({
  winopts = {
    preview = {
      layout = "vertical",
      vertical = "down:35%"
    }
  },
  keymap = {
    fzf = {
      ["ctrl-q"] = "select-all+accept",
    },
  },
})

require("render-markdown").setup {
    code = {
        enabled = true,
        sign = true,
        style = 'full',
        position = 'left',
        language_pad = 0,
        disable_background = { 'diff' },
        width = 'full',
        left_pad = 0,
        right_pad = 0,
        min_width = 0,
        border = 'thin',
        above = '▄',
        below = '▀',
        highlight = 'RenderMarkdownCode',
        highlight_inline = 'RenderMarkdownCodeInline',
    },
}

require('leap').create_default_mappings()

require('lualine').setup()
require('nvim-autopairs').setup()

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

-- MAP TAB & SHIFT TAB to navigate the completion suggestions
local cmp = require'cmp'
cmp.setup {
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' }
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
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()
require("lspconfig").ts_ls.setup{
  capabilities = capabilities,
  init_options = { 
    preferences = { 
      importModuleSpecifierPreference = 'relative', 
    },  
  },
}

require("lspconfig").tailwindcss.setup{
  capabilities = capabilities
}
require("lspconfig").terraformls.setup{
  capabilities = capabilities
}

require("lspconfig").gopls.setup{
  capabilities = capabilities
}

require("lspconfig").ruby_lsp.setup{
  capabilities = capabilities,
  filetypes = { "ruby", "eruby" },
}

require("lspconfig").hls.setup{
  capabilities = capabilities
}

require("bufferline").setup{
  options = {
    buffer_close_icon = 'x',
    show_buffer_icons = false,
  }

}
require('Comment').setup()

require('lint').linters_by_ft = {
  typescript = {'eslint_d'},
  typescriptreact = {'eslint_d'},
  javascriptreact = {'eslint_d'},
  javascript = {'eslint_d'},
  -- ruby = {'standardrb'},
}

require('gitsigns').setup {
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '[c', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    -- Actions
    map('n', '<leader>gr', gs.reset_hunk)
    map('v', '<leader>gr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
    map('n', '<leader>gR', gs.reset_buffer)
    map('n', '<leader>gp', gs.preview_hunk)
    map('n', '<leader>gb', function() gs.blame_line{full=true} end)
    map('n', '<leader>gd', gs.diffthis)
    map('n', '<leader>gD', function() gs.diffthis('~') end)

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
}


-- Formatter configuration
require("formatter").setup {
  -- Enable or disable logging
  logging = true,
  -- Set the log level
  log_level = vim.log.levels.WARN,
  -- All formatter configurations are opt-in
  filetype = {
    typescriptreact = {
      require('formatter.defaults.eslint_d')
    },
    typescript = {
      require('formatter.defaults.eslint_d')
    },
    javascript = {
      require('formatter.defaults.eslint_d')
    },
    -- eruby = require("formatter.filetypes.eruby").erbformatter,
    ruby = require("formatter.filetypes.ruby").rubocop,
    go = require('formatter.filetypes.go').gofmt
  }
}

-- Use linter for anything javascript-like
vim.api.nvim_create_autocmd({"BufWritePost", "TextChanged", "InsertLeave", "BufEnter" }, {
  pattern = { "*.tsx", "*.ts", "*.jsx", "*.js", "*.mjs", "*.mts", "*.rb"},
  callback = function()
    require("lint").try_lint()
  end,
})

-- Format anything javascript & ruby-like after save
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.tsx", "*.ts", "*.jsx", "*.js", "*.mjs", "*.mts", "*.rb", "*.erb", "*.go" },
  callback = function()
    vim.cmd("Format")
  end,
})

-- SET THEME
vim.cmd.colorscheme('duskfox')

-- KEY MAPPING
vim.keymap.set({'n', 'x'}, 'x', '"_x')

-- fzf-lua bindings
local fzflua= require('fzf-lua')
vim.keymap.set('n', '<leader>fp', fzflua.files, {})
vim.keymap.set('n', '<leader>fq', fzflua.quickfix, {})
vim.keymap.set('n', '<leader>fg', fzflua.live_grep, {})
vim.keymap.set('n', '<leader>fw', fzflua.grep_cword, {})
vim.keymap.set('n', '<leader>fs', fzflua.lsp_definitions, {})
vim.keymap.set('n', '<leader>fr', fzflua.lsp_references, {})
vim.keymap.set('n', '<leader>ca', fzflua.lsp_code_actions)
vim.keymap.set('n', '<leader>ft', fzflua.treesitter, {})
vim.keymap.set('n', '<leader>p', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>n', vim.diagnostic.goto_next)
-- close all buffers except the active one
vim.keymap.set('n', '<leader>bd', ":%bd|e#|bd#<CR>")

-- Tab navigation
vim.keymap.set('n', '<Tab>', ":bn<CR>")
vim.keymap.set('n', '<S-Tab>', ":bp<CR>")
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)

-- LSP stuff
vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

-- Window navigation using leader
vim.keymap.set("n", "<leader>wh", "<C-w>h", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>wj", "<C-w>j", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>wk", "<C-w>k", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>wl", "<C-w>l", { noremap = true, silent = true})

-- Diffview shortcut
vim.keymap.set("n", "<leader>go", ":DiffviewOpen<CR>", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>gc", ":DiffviewClose<CR>", { noremap = true, silent = true})

vim.diagnostic.config({virtual_text = false})
