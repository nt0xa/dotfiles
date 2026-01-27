-- options {{{

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

-- Use smart indent.
vim.opt.smartindent = true

-- This will cause all yank/delete/paste operations to use the system register *.
vim.opt.clipboard = { "unnamed", "unnamedplus" }

local function paste()
	return {
		vim.fn.split(vim.fn.getreg("\""), "\n"),
		vim.fn.getregtype("\""),
	}
end

if vim.fn.filereadable("/.dockerenv") == 1 then
	-- Use OSC 52 for copy to clipboard, but ignore it for paste.
	vim.g.clipboard = {
		name = "OSC 52",
		copy = {
			["+"] = require("vim.ui.clipboard.osc52").copy("+"),
			["*"] = require("vim.ui.clipboard.osc52").copy("*"),
		},
		paste = {
			-- Wezterm doesn't support OSC 52 paste.
			["+"] = paste,
			["*"] = paste,
		},
	}
end


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

-- Do not select the first completion option by default.
vim.opt.completeopt = { "menuone", "noselect" }

-- }}}

-- keymaps {{{

local opts = { noremap = true, silent = true }

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Reload config.
vim.keymap.set("n", "<leader>r", ":source $MYVIMRC<CR>", opts)

-- Write file.
vim.keymap.set("n", "<leader>w", ":w!<CR>", opts)

-- Quit the current window.
vim.keymap.set("n", "<leader>q", ":q<CR>", opts)

-- Clear last search highlighting.
vim.keymap.set("n", "<leader><leader>", ":nohlsearch<CR>", opts)

-- Close all other windows except the current.
vim.keymap.set("n", "<leader>o", ":only<CR>", opts)

-- Select pasted text.
vim.keymap.set("n", "gv", "`[v`]", opts)

-- RSI (Readline Style Insertion)

-- Go to the start of the line.
vim.keymap.set("i", "<C-a>", "<C-o>^", opts)
vim.keymap.set("c", "<C-a>", "<Home>")

-- Go to the end of the line.
vim.keymap.set("i", "<C-e>", "<C-o>$", opts)
vim.keymap.set("c", "<C-e>", "<End>")

-- Go forward.
vim.keymap.set("i", "<C-f>", "<Right>", opts)
vim.keymap.set("c", "<C-f>", "<Right>")

-- Go back.
vim.keymap.set("i", "<C-b>", "<Left>", opts)
vim.keymap.set("c", "<C-b>", "<Left>")

-- Paste.
vim.keymap.set("i", "<C-y>", "<C-o>p", opts)

-- Del.
vim.keymap.set("i", "<C-d>", "<Delete>", opts)
vim.keymap.set("c", "<C-d>", "<Delete>")

-- }}}

-- colorscheme {{{

local plugins = {}

table.insert(plugins, {
	"gbprod/nord.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		vim.g.nord_italic = false
		vim.g.nord_bold = false

		vim.cmd([[colorscheme nord]])
	end,
})

-- }}}

-- treesitter {{{

table.insert(plugins, {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",
	build = ":TSUpdate",
	config = function()
		local parsers = {
			"bash",
			"c",
			"css",
			"elixir",
			"fish",
			"git_config",
			"git_rebase",
			"gitattributes",
			"gitcommit",
			"gitignore",
			"go",
			"gomod",
			"gosum",
			"gotmpl",
			"graphql",
			"hcl",
			"html",
			"javascript",
			"json",
			"lua",
			"make",
			"markdown",
			"objc",
			"php",
			"python",
			"rust",
			"sql",
			"swift",
			"terraform",
			"toml",
			"tsx",
			"typescript",
			"yaml",
		}

		require("nvim-treesitter").install(parsers):wait(300000)

		-- Enable treesitter highlighting and indents
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local filetype = args.match
				local lang = vim.treesitter.language.get_lang(filetype)

				if vim.treesitter.language.add(lang) then
					vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					vim.treesitter.start()
				end
			end,
		})
	end,
})

table.insert(plugins, {
	"Wansmer/treesj",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("treesj").setup()
		vim.keymap.set("n", "<localleader>s", require("treesj").toggle)
	end,
})

-- }}}

-- completion {{{

table.insert(plugins, {
	"saghen/blink.cmp",
	dependencies = {
		"fang2hou/blink-copilot",
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
			config = function()
				require("luasnip.loaders.from_lua").lazy_load()
			end,
		},
	},
	version = "1.*",
	opts = {
		keymap = { preset = "default" },
		snippets = { preset = "luasnip" },
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "copilot" },
			providers = {
				copilot = {
					name = "copilot",
					module = "blink-copilot",
					async = true,
				},
			},
		},
	},
	opts_extend = { "sources.default" },
})

-- }}}

-- lsp {{{

table.insert(plugins, {
	"neovim/nvim-lspconfig",
	lazy = false,
	config = function()
		vim.lsp.enable({
			"gopls",
			"golangci_lint_ls",
      "ruff",
      "ty",
			"copilot",
		})

		vim.diagnostic.config({
			float = { border = "rounded" },
			virtual_text = false,
			signs = true,
		})

		local bufopts = { noremap = true, silent = true, buffer = bufnr }
		vim.keymap.set("n", "K", function() vim.lsp.buf.hover { border = "rounded" } end, bufopts)
		vim.keymap.set("n", "<C-k>", function() vim.lsp.buf.signature_help { border = "rounded" } end, bufopts)
		vim.keymap.set("n", "<localleader>f", function() vim.lsp.buf.format({ async = false }) end, bufopts)
		vim.keymap.set("n", "<localleader>e", vim.diagnostic.open_float)
		vim.keymap.set("n", "<localleader>a", vim.lsp.buf.code_action, bufopts)
	end,
})

-- }}}

-- telescope {{{

table.insert(plugins, {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-file-browser.nvim",
	},
	keys = {
		{ "<leader>f", "<cmd>Telescope find_files theme=dropdown<cr>" },
		{ "<leader>g", "<cmd>Telescope live_grep theme=dropdown<cr>" },
		{ "<leader>b", "<cmd>Telescope buffers theme=dropdown<cr>" },
		{ "<leader>s", "<cmd>Telescope lsp_document_symbols theme=dropdown<cr>" },
		{ "<leader>a", "<cmd>Telescope lsp_dynamic_workspace_symbols theme=dropdown<cr>" },
		{ "<leader>e", "<cmd>Telescope diagnostics theme=dropdown<cr>" },
		{ "<leader>d", "<cmd>Telescope file_browser path=%:p:h select_buffer=true theme=dropdown<cr>" },
		{ "<leader>r", "<cmd>Telescope lsp_references theme=dropdown<cr>" },
		{ "<leader>t", "<cmd>Telescope lsp_definitions theme=dropdown<cr>" },
		{ "<leader>i", "<cmd>Telescope lsp_implementations theme=dropdown<cr>" },
	},
	opts = function()
		local actions = require("telescope.actions")
		local fb_actions = require("telescope").extensions.file_browser.actions
		return require("telescope.themes").get_dropdown({
			extensions = {
				file_browser = {
					initial_mode = "normal",
					respect_gitignore = true,
					grouped = true,
					hijack_netrw = true,
					git_status = false,
					mappings = {
						["n"] = {
							["h"] = fb_actions.goto_parent_dir,
							["l"] = actions.select_default,
							["."] = fb_actions.toggle_hidden,
						},
					}
				},
			},
		})
	end,
	config = function(_, opts)
		require("telescope").setup(opts)
		require("telescope").load_extension("file_browser")
	end,
})

-- }}}

-- lazy.nvim {{{

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(plugins)

-- }}}
