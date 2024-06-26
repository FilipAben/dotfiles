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
vim.g.mapleader = ' '
vim.g.mkdp_auto_close = 0
vim.g.marked_filetypes = {"markdown"}

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
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "lewis6991/gitsigns.nvim",
  "numToStr/Comment.nvim",
  "mfussenegger/nvim-lint",
  "mhartington/formatter.nvim",
  "windwp/nvim-autopairs",
  "https://gitlab.com/HiPhish/rainbow-delimiters.nvim",
  {"akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons"},
  {"nvim-telescope/telescope.nvim", dependencies = { 'nvim-lua/plenary.nvim' } },
  {"nvim-telescope/telescope-file-browser.nvim", dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }},
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  { 'ggandor/leap.nvim' },
-- install with yarn or npm
{
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  build = "cd app && yarn install",
  init = function()
    vim.g.mkdp_filetypes = { "markdown" }
  end,
  ft = { "markdown" },
},
})

require('leap').create_default_mappings()

require('nvim-treesitter').setup({
  ensure_installed = { "ruby", "embedded_template" }
})

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
require("lspconfig").tsserver.setup{
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

require("lspconfig").solargraph.setup{
  capabilities = capabilities
}

require("mason").setup()
require("mason-lspconfig").setup()
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
    eruby = require("formatter.filetypes.eruby").erbformatter,
    ruby = {
      function()
        local util = require "formatter.util"
        return {
          exe = "standardrb",
          args = {
            "--fix",
            "--format",
            "quiet",
            "--stderr",
            "--stdin",
            util.escape_path(util.get_current_buffer_file_path()),
          },
          stdin = true,
          ignore_exitcode = true,
        }
      end
    }
  }
}

require('telescope').setup{ 
  defaults = { 
    file_ignore_patterns = { "node_modules", ".git" }, 
    layout_strategy = "vertical",
  },
  pickers = {
    find_files = {
      hidden = true,
    },
  },
}

-- vim.opt.signcolumn = "yes" -- otherwise it bounces in and out, not strictly needed though
vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  group = vim.api.nvim_create_augroup("RubyLSP", { clear = true }), -- also this is not /needed/ but it's good practice 
  callback = function()
    vim.lsp.start {
      name = "standard",
      cmd = { "/Users/filip/.rbenv/shims/standardrb", "--lsp" },
    }
  end,
})

-- Use linter for anything javascript-like
vim.api.nvim_create_autocmd({"BufWritePost", "TextChanged", "InsertLeave", "BufEnter" }, {
  pattern = { "*.tsx", "*.ts", "*.jsx", "*.js", "*.mjs", "*.mts"},
  callback = function()
    require("lint").try_lint()
  end,
})

-- Format anything javascript & ruby-like after save
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "*.tsx", "*.ts", "*.jsx", "*.js", "*.mjs", "*.mts", "*.rb", "*.erb" },
  callback = function()
    vim.cmd("Format")
  end,
})

-- SET THEME
vim.cmd.colorscheme('duskfox')

-- KEY MAPPING
vim.keymap.set({'n', 'x'}, 'x', '"_x')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fp', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fw', builtin.grep_string, {})
vim.keymap.set('n', '<leader>fs', builtin.lsp_dynamic_workspace_symbols, {})
vim.keymap.set("n", "<leader>ft", ":Telescope file_browser<CR>")
vim.keymap.set("n", "<leader>fc", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")

vim.keymap.set('n', '<leader>p', vim.diagnostic.goto_prev)
vim.keymap.set('n', '<leader>n', vim.diagnostic.goto_next)
-- close all buffers except the active one
vim.keymap.set('n', '<leader>bd', ":%bd|e#|bd#<CR>")

vim.keymap.set('n', '<Tab>', ":bn<CR>")
vim.keymap.set('n', '<S-Tab>', ":bp<CR>")
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.api.nvim_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { noremap = true, silent = true })

-- Window navigation using leader
vim.keymap.set("n", "<leader>wh", "<C-w>h", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>wj", "<C-w>j", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>wk", "<C-w>k", { noremap = true, silent = true})
vim.keymap.set("n", "<leader>wl", "<C-w>l", { noremap = true, silent = true})

vim.diagnostic.config({virtual_text = false})
