return {
  {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring"
    },
    keys = { { "gc", mode = "v" }, "gcc" },
    config = function()
      require("Comment").setup()
    end,
  }
}
