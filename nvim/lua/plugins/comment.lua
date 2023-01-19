return {
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring"
    },
    keys = { "gc", "gcc", "gbc" },
    config = function()
      require("Comment").setup()
    end,
  }
}
