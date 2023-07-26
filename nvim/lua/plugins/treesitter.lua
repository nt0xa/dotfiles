return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "JoosepAlviste/nvim-ts-context-commentstring"
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
        "gotmpl"
      },
      sync_install = true,
      highlight = {
        enable = true,
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

      -- nvim-ts-context-commentstring
      -- this should be used with commenting plugin like "numToStr/Comment.nvim"
      context_commentstring = { enable = true },
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
  }
}
