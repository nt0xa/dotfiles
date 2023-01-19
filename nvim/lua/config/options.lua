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
