return {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "j-hui/fidget.nvim", config = true },
      { "smjonas/inc-rename.nvim", config = true },
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function(plugin, opts)
      vim.keymap.set("n", "<leader>l", ":LspStart<CR>", { noremap = true, silent = true })

      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
        vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set("n", "<space>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set("n", "<localleader>D", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "<localleader>rn", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<localleader>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        vim.keymap.set("n", "<localleader>f", function() vim.lsp.buf.format { async = true } end, bufopts)
        vim.keymap.set("n", "<localleader>e", vim.diagnostic.open_float, bufopts)
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
      local null_ls_sources = {}

      -- Golang
      if vim.fn.filereadable("/.nvim-go") == 1 then
        lsps["gopls"] = {}
        table.insert(null_ls_sources, formatting.gofmt)
        table.insert(null_ls_sources, formatting.goimports)
      end

      -- Python
      if vim.fn.filereadable("/.nvim-python") == 1 then
        lsps["pylsp"] = {}
        table.insert(null_ls_sources, diagnostics.mypy)
        table.insert(null_ls_sources, formatting.black)
        table.insert(null_ls_sources, formatting.reorder_python_imports)
      end

      -- Javascript / Typescript / HTML / CSS
      if vim.fn.filereadable("/.nvim-web") == 1 then
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
