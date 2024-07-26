return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "nvimtools/none-ls.nvim",
      "jay-babu/mason-null-ls.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function(plugin, opts)
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          -- Shell
          "bashls",

          -- Golang
          "gopls",
          "golangci_lint_ls",
          "templ",

          -- Rust
          "rust_analyzer",

          -- Python
          "pyright",
          "ruff_lsp",

          -- Web
          "tsserver",
          "html",
          "cssls",
          "tailwindcss",

          -- PHP
          "intelephense",
        },
      })

      require("mason-null-ls").setup({
        ensure_installed = {
          -- Shell
          "shfmt",

          -- Golang
          "goimports",
          "gomodifytags",

          -- Python
          "mypy",

          -- Web
          "prettier",
        }
      })


      vim.keymap.set("n", "<leader>l", ":LspStart<CR>", { noremap = true, silent = true })

      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local on_attach = function(client, bufnr)
        -- Diagnostics window borders.
        local border = "rounded"

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
          vim.lsp.handlers.hover, {
            border = border
          }
        )

        vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
          vim.lsp.handlers.signature_help, {
            border = border
          }
        )

        vim.diagnostic.config {     
          float = { border = border }, 
          virtual_text = false,
          signs = true
        }

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<localleader>d", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "<localleader>r", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<localleader>a", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "<localleader>f", function() vim.lsp.buf.format { async = false } end, bufopts)
        vim.keymap.set("n", "<localleader>e", vim.diagnostic.open_float, bufopts)
        vim.keymap.set("n", "gn", vim.diagnostic.goto_next, bufopts)
        vim.keymap.set("n", "gp", vim.diagnostic.goto_prev, bufopts)

      end

      -- null-ls helpers
      local null_ls = require("null-ls")
      local code_actions = null_ls.builtins.code_actions
      local diagnostics = null_ls.builtins.diagnostics
      local formatting = null_ls.builtins.formatting
      local hover = null_ls.builtins.hover
      local completion = null_ls.builtins.completion

      -- lsp servers
      local lsps = {}

      -- null-ls sources
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
      local null_ls_sources = {}

      -- Shell
      if vim.fn.executable("node") == 1 then
        lsps["bashls"] = {}
        table.insert(null_ls_sources, formatting.shfmt)
      end

      -- Golang
      if vim.fn.executable("go") == 1 then
        lsps["gopls"] = {}
        lsps["templ"] = {}
        lsps["golangci_lint_ls"] = {}
        table.insert(null_ls_sources, formatting.goimports)
        table.insert(null_ls_sources, code_actions.gomodifytags)
      end

      -- Python
      if vim.fn.executable("python3") == 1 then
        lsps["pyright"] = {}
        lsps["ruff_lsp"] = {}
        table.insert(null_ls_sources, diagnostics.mypy)
      end

      -- Javascript / Typescript / HTML / CSS
      if vim.fn.executable("node") == 1 then
        lsps["tsserver"] = {}
        lsps["html"] = {
          init_options = {
            provideFormatter = false
          },
          filetypes = { "html", "templ" }
        }
        lsps["cssls"] = {}
        lsps["tailwindcss"] = {
          filetypes = { "templ", "javascript", "typescript", "react" },
          init_options = { userLanguages = { templ = "html" } },
        }
        table.insert(null_ls_sources, formatting.prettier)
      end

      -- Rust
      if vim.fn.executable("cargo") == 1 then
        lsps["rust_analyzer"] = {}
      end

      -- Rust
      if vim.fn.executable("php") == 1 then
        lsps["intelephense"] = {}
        table.insert(null_ls_sources, formatting.prettier)
      end

      local lspconfig = require("lspconfig")

      for _, lsp in ipairs(vim.tbl_keys(lsps)) do
        local common = { on_attach = on_attach, capabilities = capabilities }
        local opts = vim.tbl_deep_extend("force", common, lsps[lsp])
        lspconfig[lsp].setup(opts)
      end

      null_ls.setup {
        sources = null_ls_sources,
      }
    end,
  }
}
