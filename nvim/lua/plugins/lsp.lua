return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "jose-elias-alvarez/null-ls.nvim",
      "williamboman/mason.nvim",
		  "williamboman/mason-lspconfig.nvim",
    },
    config = function(plugin, opts)
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "gopls",
          "rust_analyzer",
          "pylsp",
          "tsserver",
          "html",
          "cssls",
          "tailwindcss",
        },
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
        }

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<localleader>d", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "<localleader>r", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<localleader>a", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "<localleader>f", function() vim.lsp.buf.format { async = true } end, bufopts)
        vim.keymap.set("n", "<localleader>e", vim.diagnostic.open_float, bufopts)
        vim.keymap.set("n", "<localleader>n", vim.diagnostic.goto_next, bufopts)
        vim.keymap.set("n", "<localleader>p", vim.diagnostic.goto_prev, bufopts)

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

      -- Golang
      if vim.fn.executable("go") == 1 then
        lsps["gopls"] = {}
        table.insert(null_ls_sources, formatting.gofmt)
        table.insert(null_ls_sources, formatting.goimports)
      end

      -- Python
      if vim.fn.executable("python3") == 1 then
        lsps["pylsp"] = {}
        table.insert(null_ls_sources, diagnostics.mypy)
        table.insert(null_ls_sources, formatting.black)
        table.insert(null_ls_sources, formatting.reorder_python_imports)
      end

      -- Javascript / Typescript / HTML / CSS
      if vim.fn.executable("node") == 1 then
        lsps["tsserver"] = {}
        lsps["html"] = {
          init_options = {
            provideFormatter = false
          }
        }
        lsps["cssls"] = {}
        lsps["tailwindcss"] = {}
        table.insert(null_ls_sources, diagnostics.tcs)
        table.insert(null_ls_sources, formatting.prettier)
      end

      -- Rust
      if vim.fn.executable("cargo") == 1 then
        lsps["rust_analyzer"] = {}
        table.insert(null_ls_sources, formatting.rustfmt)
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
