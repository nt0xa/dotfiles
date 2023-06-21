return {
  "nvim-telescope/telescope-file-browser.nvim",
  lazy = false,
  version = "0.1.1",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local fb_actions =  telescope.extensions.file_browser.actions

    telescope.setup({
      defaults = {
        mappings = {
          ["i"] = {
            ["<esc>"] = actions.close,
            ["<C-u>"] = false,
          },
          ["n"] = {
            ["q"] = actions.close,
          },
        },
      },
      extensions = {
        file_browser = {
          theme = "dropdown",
          initial_mode = "normal",
          path = "%:p:h",
          respect_gitignore = true,
          hidden = false,
          grouped = true,
          previewer = false,
          initial_mode = "normal",
          layout_config = { height = 40 },
          git_status = false,
          hijack_netrw = true,
          mappings = {
            ["i"] = {
            },
            ["n"] = {
              ["n"] = fb_actions.create,
              ["d"] = fb_actions.remove,
              ["r"] = fb_actions.rename,
              ["h"] = fb_actions.goto_parent_dir,
              ["l"] = actions.select_default,
              ["."] = fb_actions.toggle_hidden,
              ["/"] = function()
                vim.cmd('startinsert')
              end
            },
          },
        },
      },
    })

    telescope.load_extension("file_browser")

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<leader>f", builtin.find_files, {})
    vim.keymap.set("n", "<leader>g", builtin.live_grep, {})
    vim.keymap.set("n", "<leader>b", builtin.buffers, {})
    vim.keymap.set("n", "<space>d", function()
      telescope.extensions.file_browser.file_browser({
        path = "%:p:h",
        select_buffer = true, -- highligh current file
      })
    end)
  end
}
