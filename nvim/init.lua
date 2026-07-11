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
		vim.fn.split(vim.fn.getreg('"'), "\n"),
		vim.fn.getregtype('"'),
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

-- Completion: always show menu, don't auto-select, fuzzy match.
vim.opt.completeopt = { "menuone", "noselect", "fuzzy" }

-- Limit the completion popup to at most 10 visible items (scrolls beyond that).
vim.opt.pumheight = 10

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

-- Del.
vim.keymap.set("i", "<C-d>", "<Delete>", opts)
vim.keymap.set("c", "<C-d>", "<Delete>")

-- }}}

-- vim.pack {{{

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind

		if name == "nvim-treesitter" and kind == "update" then
			if not ev.data.active then
				vim.cmd.packadd("nvim-treesitter")
			end
			vim.cmd("TSUpdate")
		end

		if name == "LuaSnip" and (kind == "install" or kind == "update") then
			vim.system({ "make install_jsregexp" }, { cwd = ev.data.path })
		end
	end,
})

vim.pack.add({
	"https://github.com/gbprod/nord.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/echasnovski/mini.completion",
	"https://github.com/echasnovski/mini.pick",
	"https://github.com/echasnovski/mini.extra",
	"https://github.com/stevearc/oil.nvim",
	{
		src = "https://github.com/L3MON4D3/LuaSnip",
		version = vim.version.range("2.0.0"),
	},
})

-- }}}

-- colorscheme {{{

vim.g.nord_italic = false
vim.g.nord_bold = false
vim.cmd([[colorscheme nord]])

-- }}}

-- nvim-treesitter {{{

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

-- }}}

-- nvim-lspconfig {{{

vim.lsp.enable({
	"gopls",
	"golangci_lint_ls",
	"ruff",
	"ty",
	"ts_ls",
	"biome",
})

vim.diagnostic.config({
	float = { border = "rounded" },
	virtual_text = false,
	signs = true,
})

local bufopts = { noremap = true, silent = true, buffer = bufnr }
vim.keymap.set("n", "K", function()
	vim.lsp.buf.hover({ border = "rounded" })
end, bufopts)
vim.keymap.set("n", "<C-k>", function()
	vim.lsp.buf.signature_help({ border = "rounded" })
end, bufopts)
vim.keymap.set("n", "<localleader>f", function()
	vim.lsp.buf.format({ async = false })
end, bufopts)
vim.keymap.set("n", "<localleader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<localleader>a", vim.lsp.buf.code_action, bufopts)

-- }}}

-- luasnip {{{

require("luasnip.loaders.from_lua").lazy_load()

-- }}}

-- mini.completion {{{

local completion = require("mini.completion")

completion.setup({
	-- disable completion by setting long delay.
	delay = { signature = 10^7 },
	-- Keep our own completeopt (fuzzy), pumheight and shortmess settings.
	set_vim_settings = false,
	-- Set up LSP completion per client attach instead of on every BufEnter.
	lsp_completion = { source_func = "omnifunc", auto_setup = false },
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
	end,
})

-- Scroll the info/signature window with <C-f>/<C-b> when it's open, otherwise
-- keep the RSI cursor movement (<Right>/<Left>). Defined after setup so these
-- override mini.completion's own scroll mappings.
vim.keymap.set("i", "<C-f>", function()
	return completion.scroll("down") and "" or "<Right>"
end, { expr = true })

vim.keymap.set("i", "<C-b>", function()
	return completion.scroll("up") and "" or "<Left>"
end, { expr = true })

-- }}}

-- mini.pick {{{

local pick = require("mini.pick")
local extra = require("mini.extra")

pick.setup()
extra.setup()

local map = vim.keymap.set
local opt = { noremap = true, silent = true }

map("n", "<leader>f", pick.builtin.files, opt)
map("n", "<leader>g", pick.builtin.grep_live, opt)
map("n", "<leader>b", pick.builtin.buffers, opt)
map("n", "<leader>s", function()
	extra.pickers.lsp({ scope = "document_symbol" })
end, opt)
map("n", "<leader>a", function()
	extra.pickers.lsp({ scope = "workspace_symbol" })
end, opt)
map("n", "<leader>e", function()
	extra.pickers.diagnostic()
end, opt)
map("n", "<leader>r", function()
	extra.pickers.lsp({ scope = "references" })
end, opt)
map("n", "<leader>t", function()
	extra.pickers.lsp({ scope = "definition" })
end, opt)
map("n", "<leader>i", function()
	extra.pickers.lsp({ scope = "implementation" })
end, opt)

-- }}}

-- oil {{{

local oil = require("oil")

oil.setup({
	default_file_explorer = true,
})

local map = vim.keymap.set
local opt = { noremap = true, silent = true }

-- Toggle the explorer: close it if focused, otherwise open the parent
-- directory of the current file. Selecting a file with <CR> opens it in the
-- same window, replacing the oil buffer.
map("n", "<leader>d", function()
	if vim.bo.filetype == "oil" then
		oil.close()
	else
		oil.open()
	end
end, opt)

-- }}}
