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

-- RSI (Readline Style Insertion)

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
