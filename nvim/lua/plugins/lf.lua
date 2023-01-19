return {
  {
    -- TODO: Change to "lmburns/lf.nvim" when https://github.com/lmburns/lf.nvim/pull/10 is merged
    "russtone/lf.nvim",
    keys = { "<leader>d" },
    dependencies = {
      "akinsho/toggleterm.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function() 
      require("lf").setup {
        border = "rounded",
        highlights = {
          FloatBorder = { 
            guifg = "#DFDFE0", -- TODO: use color from colorscheme
          }
        },
      }

      vim.keymap.set("n", "<leader>d", function()
        require("lf").start()
      end, { noremap = true })
    end,
  }
}
