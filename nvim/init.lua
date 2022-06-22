-- Plugins {{{

local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
end

require("packer").startup(function(use)
  -- Packer itself
  use("wbthomason/packer.nvim")

  -- Syntax highlighting
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use("nvim-treesitter/nvim-treesitter-textobjects")

  -- LSP
  use({
    "neovim/nvim-lspconfig", -- easy LSP servers configurations
    "williamboman/nvim-lsp-installer", -- easy LSP servers install
  })

  -- Completion
  use({
    -- Addons
    "hrsh7th/cmp-nvim-lsp", -- completions from LSP
    "hrsh7th/cmp-buffer", -- completions from current buffer words
    "hrsh7th/cmp-path", -- completions from current directory paths
    "hrsh7th/cmp-cmdline", -- completions for vim cmd mode
    "saadparwaiz1/cmp_luasnip", -- completions for luasnip

    -- The main module
    "hrsh7th/nvim-cmp",
  })

  -- Formatter
  use("mhartington/formatter.nvim")

  -- Commentary
  use("b3nj5m1n/kommentary")

  -- Snippets
  use("L3MON4D3/LuaSnip")

  -- FZF
  use("ibhagwan/fzf-lua")

  -- Utils
  use("nvim-lua/popup.nvim")
  use("nvim-lua/plenary.nvim")
  use("akinsho/toggleterm.nvim")
end)

-- }}}

-- Settings {{{

-- Show line numbers.
vim.opt.number = true

-- Always show status line,
-- show only one global status line.
vim.opt.laststatus = 3

-- Do not show '-- INSERT --' and other markers at the bottom.
vim.opt.showmode = false

-- Enable fold, use marker.
vim.opt.foldenable = true
vim.opt.foldmethod = "marker"

-- Case insensetive search.
vim.opt.ignorecase = true

-- Use case sensetive search if pattern contains upppercase letters.
vim.opt.smartcase = true

-- This will cause all yank/delete/paste operations to use the system register *.
vim.opt.clipboard = { "unnamed", "unnamedplus" }

-- Enable mouse in all modes.
vim.opt.mouse = "a"

-- Enables 24-bit RGB color in the TUI.
vim.opt.termguicolors = true

-- Count of spaces per tab when editing.
vim.opt.softtabstop = 2

-- Number of visual spaces per tab.
vim.opt.tabstop = 2

-- <<, >> spaces.
vim.opt.shiftwidth = 2

-- Use spaces for indent
vim.opt.expandtab = true

-- Display tabs and trailing spaces visual.
vim.opt.list = true
vim.opt.listchars = { tab = "➝ ", eol = "¬" }

-- Don't wrap long lines.
vim.opt.wrap = false

-- Disable backup & swap files.
vim.opt.writebackup = false
vim.opt.swapfile = false

-- Keep lines below cursor when scrolling.
vim.opt.scrolloff = 2
vim.opt.sidescrolloff = 5

-- Always show sign column.
vim.opt.signcolumn = "yes"

-- Suppress the annoying 'match x of y', 'The only match' and 'Pattern not found' messages.
vim.opt.shortmess:append("c")

-- Status line
vim.opt.statusline = "%#StatusLineFile#"
  .. " %f %m %r %w"
  .. "%="
  .. "%#StatusLinePercent#"
  .. " %3p%% "
  .. "%#StatusLinePosition#"
  .. " %l:%c "

-- Colorscheme
vim.cmd("colorscheme xcode")

vim.api.nvim_set_hl(0, "StatusLine", { fg = "#DFDFE0", bg = "#2F3238" })
vim.api.nvim_set_hl(0, "StatusLinePosition", { fg = "#DFDFE0", bg = "#7f8c98", bold = true })

--- }}}

-- Keymappings {{{

-- leader & localleader.
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Reload config.
vim.keymap.set("n", "<leader>r", ":source $MYVIMRC<CR>")

-- Write file.
vim.keymap.set("n", "<leader>w", ":w!<CR>")

-- Quit the current window.
vim.keymap.set("n", "<leader>q", ":q<CR>")

-- Clear last search highlighting.
vim.keymap.set("n", "<leader><leader>", ":nohlsearch<CR>")

-- Close all other windows except the current.
vim.keymap.set("n", "<leader>o", ":only<CR>")

-- Select pasted text.
vim.keymap.set("n", "gv", "`[v`]")

-- RSI (Readline Style Insertion) {{{

-- Go to the start of the line.
vim.keymap.set("i", "<C-a>", "<C-o>^")
vim.keymap.set("c", "<C-a>", "<C-o>0")

-- Go to the end of the line.
vim.keymap.set("i", "<C-e>", "<C-o>$")

-- Go forward.
vim.keymap.set("i", "<C-f>", "<Right>")
vim.keymap.set("c", "<C-f>", "<Right>")

-- Go back.
vim.keymap.set("i", "<C-b>", "<Left>")

-- Paste.
vim.keymap.set("i", "<C-y>", "<C-o>p")

-- Del.
vim.keymap.set("i", "<C-d>", "<Delete>")

-- }}}

-- }}}

-- Treesitter & textobjects {{{

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "c",
    "lua",
    "go",
    "python",
    "javascript",
    "typescript",
    "html",
    "hcl",
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = false,
  },
})

require("nvim-treesitter.configs").setup({
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["gl"] = "@parameter.inner",
      },
      swap_previous = {
        ["gh"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
})

-- }}}

-- LSP & Completion {{{

local lspconfig = require("lspconfig")

-- vim.lsp.set_log_level('debug')

local on_attach = function(_, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  local opts = { noremap = true, silent = true }

  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "<localleader>n", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<leader>n", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "<leader>p", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<localleader>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
  buf_set_keymap("n", "<localleader>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
end

-- Servers
local servers = {
  "gopls",
  "tsserver",
  "pyright",
  "sourcekit",
  "sumneko_lua",
}

-- LSP installer
require("nvim-lsp-installer").setup({
  ensure_installed = servers,
  automatic_installation = true,
})

-- CMP
local cmp = require("cmp")
local luasnip = require("luasnip")

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping(function(fallback)
      if luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = "luasnip", max_item_count = 10, priority = 10 },
    { name = "nvim_lsp", max_item_count = 10 },
  }, {
    { name = "buffer", max_item_count = 10 },
  }),
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path", max_item_count = 10 },
  }, {
    { name = "cmdline", max_item_count = 10 },
  }, {
    name = "buffer",
  }),
})

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

for _, lsp in ipairs(servers) do
  local opts = { on_attach = on_attach, capabilities = capabilities }

  -- LUA
  if lsp == "sumneko_lua" then
    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    opts["settings"] = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { "vim" },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    }
  end

  lspconfig[lsp].setup(opts)
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
  underline = true,
  virtual_text = false,
  signs = true,
  update_in_insert = false,
})

-- }}}

-- LF {{{

local Terminal = require("toggleterm.terminal").Terminal

local function lf_toggle()
  local curfile = vim.fn.expand("%:p")
  local selection = vim.fn.tempname()

  Terminal
    :new({
      cmd = "lf " .. "-selection-path " .. vim.fn.shellescape(selection) .. " " .. vim.fn.shellescape(curfile),
      hidden = true,
      close_on_exit = true,
      direction = "float",
      float_opts = {
        border = "curved",
      },
      highlights = {
        NormalFloat = {
          link = "Normal",
        },
        FloatBorder = {
          guifg = "#DFDFE0",
        },
      },
      on_open = function(_)
        vim.cmd("startinsert!")
      end,
      on_exit = function(term)
        term:shutdown()

        -- Open selected file if there is any.
        if vim.fn.filereadable(selection) then
          local selected = vim.fn.readfile(selection)
          if #selected >= 1 then
            vim.cmd("edit " .. selected[1])
          end
          vim.fn.delete(selection)
        end
      end,
    })
    :toggle(nil, nil)
end

vim.keymap.set("n", "<leader>d", lf_toggle)

--- }}}

-- Kommentary {{{

vim.keymap.set("n", "gcc", "<Plug>kommentary_line_default")
vim.keymap.set("n", "gc", "<Plug>kommentary_motion_default")
vim.keymap.set("v", "gc", "<Plug>kommentary_visual_default<C-c>")

-- }}}

-- FZF {{{

vim.keymap.set("n", "<leader>f", function()
  require("fzf-lua").files()
end)

-- }}}

-- Formatter {{{

vim.keymap.set("n", "<localleader>f", "<cmd>FormatWrite<CR>")

require("formatter").setup({
  logging = false,
  filetype = {
    go = {
      function()
        return {
          exe = "gofmt",
          args = {},
          stdin = true,
        }
      end,
      function()
        return {
          exe = "goimports",
          args = {},
          stdin = true,
        }
      end,
    },
    javascript = {
      function()
        return {
          exe = "prettier",
          args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote" },
          stdin = true,
        }
      end,
    },
    typescript = {
      function()
        return {
          exe = "prettier",
          args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
          stdin = true,
        }
      end,
    },
    python = {
      function()
        return {
          exe = "black",
          args = { "-" },
          stdin = true,
        }
      end,
    },
    lua = {
      function()
        return {
          exe = "stylua",
          args = {
            "--config-path",
            os.getenv("XDG_CONFIG_HOME") .. "/stylua/stylua.toml",
            "-",
          },
          stdin = true,
        }
      end,
    },
  },
})

-- }}}

-- Snippets {{{

require("luasnip.loaders.from_lua").lazy_load()

vim.api.nvim_create_user_command("LuaSnipEdit", function()
  require("luasnip.loaders.from_lua").edit_snippet_files()
end, {})

-- }}}
