return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = "*",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "vrischmann/tree-sitter-templ",
    },
    build = ":TSUpdate",
    event = "BufReadPost",
    cmd = "TSUpdate",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "css",
        "dockerfile",
        "go",
        "hcl",
        "html",
        "javascript",
        "lua",
        "python",
        "typescript",
        "tsx",
        "yaml",
        "json",
        "jsonc",
        "gotmpl",
        "terraform",
        "php",
        "graphql",
      },
      sync_install = false,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
        disable = { "python" },
      },

      -- nvim-treesitter-textobjects
      textobjects = {
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["gl"] = "@parameter.inner",
          },
          swap_previous = {
            ["gh"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]]"] = "@class.outer",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]["] = "@class.outer",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[["] = "@class.outer",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[]"] = "@class.outer",
          },
        },
      },
    },
    config = function(_, opts)
      -- add golang template parser grammar
      local parser_config = require"nvim-treesitter.parsers".get_parser_configs()
      parser_config.gotmpl = {
        install_info = {
          url = "https://github.com/ngalaiko/tree-sitter-go-template",
          files = {"src/parser.c"}
        },
        filetype = "gotmpl",
        used_by = {"gohtmltmpl", "gotexttmpl", "gotmpl", "yaml", "sql"}
      }

      require("nvim-treesitter.configs").setup(opts)
    end,
  },
  {
    "Wansmer/treesj",
    keys = { "<localleader>m", "<localleader>j", "<localleader>s" },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local treesj = require("treesj")

      treesj.setup({
        use_default_keymaps = false,
      })

      vim.keymap.set("n", "<localleader>s", function() treesj.split() end, {})
      vim.keymap.set("n", "<localleader>j", function() treesj.join() end, {})

    end,
  }
}
