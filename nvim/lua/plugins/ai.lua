local username = vim.fn.expand('$USER')

if username == 'bytedance' then
  return {
    "https://code.byted.org/chenjiaqi.cposture/codeverse.vim.git",
    event = "InsertEnter",
    config = function()
      vim.g.marscode_disable_autocompletion = true
      vim.g.marscode_no_map_tab = true
      vim.g.marscode_disable_bindings = true
      require("marscode").setup({})
    end
  }
else 
  return {
    "zbirenbaum/copilot-cmp",
    event = "InsertEnter",
    config = function () require("copilot_cmp").setup() end,
    dependencies = {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      config = function()
        require("copilot").setup({
          suggestion = { enabled = false },
          panel = { enabled = false },
        })
      end,
    },
  }
end
