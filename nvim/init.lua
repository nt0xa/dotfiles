-- Set leader & localleader before lazy.nvim to be able
-- to use <leader> and <localleader> as triggers for loading plugins.
vim.g.mapleader = " "
vim.g.maplocalleader = ","

require("config.lazy")
require("config.options")
require("config.keymaps")
require("config.filetypes")
