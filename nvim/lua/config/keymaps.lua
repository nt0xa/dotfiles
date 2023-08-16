local opts = { noremap = true, silent = true }

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
