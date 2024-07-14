return {
  "nvim-telescope/telescope.nvim",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    {
      "nvim-telescope/telescope-live-grep-args.nvim",
      version = "^1.0.0",
    },
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
              '--no-ignore',
              '-E',
              '.git/*',
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
          no_ignore = true,
          initial_mode = "normal",
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

    local themes = require("telescope.themes")
    local builtin = require("telescope.builtin")

    vim.keymap.set("n", "gr", function() builtin.lsp_references(themes.get_dropdown({})) end, {})
    vim.keymap.set("n", "gd", function() builtin.lsp_definitions(themes.get_dropdown({})) end, {})
    vim.keymap.set("n", "gi", function() builtin.lsp_implementations(themes.get_dropdown({})) end, {})

    vim.keymap.set("n", "<leader>f", function() builtin.find_files(themes.get_dropdown({})) end, {})
    vim.keymap.set("n", "<leader>g", function() telescope.extensions.live_grep_args.live_grep_args((themes.get_dropdown({}))) end, {})
    vim.keymap.set("n", "<leader>b", function() builtin.buffers(themes.get_dropdown({})) end, {})
    vim.keymap.set("n", "<leader>s", function() builtin.lsp_document_symbols(themes.get_dropdown({})) end, {})
    vim.keymap.set("n", "<leader>a", function() builtin.lsp_dynamic_workspace_symbols(themes.get_dropdown({})) end, {})
    vim.keymap.set("n", "<leader>e", function() builtin.diagnostics(themes.get_dropdown({})) end, {})
    vim.keymap.set("n", "<leader>d",  function() telescope.extensions.file_browser.file_browser(themes.get_dropdown({})) end)
  end
}
