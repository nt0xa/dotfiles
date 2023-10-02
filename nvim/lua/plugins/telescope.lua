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
        theme = "dropdown",
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
      pickers = {
        find_files = {
          find_command = {
              'fd',
              '--type',
              'f',
              '--color=never',
              '--hidden',
              '--follow',
              '-E',
              '.git/*'
          },
        },
      },
      extensions = {
        file_browser = {
          theme = "dropdown",
          initial_mode = "normal",
          path = "%:p:h",
          select_buffer = true,
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
              ["c"] = fb_actions.copy,
              ["m"] = fb_actions.move,
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

    local themes = require('telescope.themes')
    local builtin = require("telescope.builtin")

    vim.keymap.set("n", "gr", function() builtin.lsp_references(themes.get_dropdown({})) end, {})
    vim.keymap.set("n", "gd", function() builtin.lsp_definitions(themes.get_dropdown({})) end, {})
    vim.keymap.set("n", "gi", function() builtin.lsp_implementations(themes.get_dropdown({})) end, {})

    vim.keymap.set("n", "<leader>f", function() builtin.find_files(themes.get_dropdown({})) end, {})
    vim.keymap.set("n", "<leader>g", function() builtin.live_grep(themes.get_dropdown({})) end, {})
    vim.keymap.set("n", "<leader>b", function() builtin.buffers(themes.get_dropdown({})) end, {})
    vim.keymap.set("n", "<leader>s", function() builtin.lsp_document_symbols(themes.get_dropdown({})) end, {})
    vim.keymap.set("n", "<leader>a", function() builtin.lsp_dynamic_workspace_symbols(themes.get_dropdown({})) end, {})
    vim.keymap.set("n", "<leader>d",  function() telescope.extensions.file_browser.file_browser(themes.get_dropdown({})) end)
  end
}
