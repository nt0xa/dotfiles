-- lspconfig {{{

local lspconfig = require('lspconfig')

-- vim.lsp.set_log_level('debug')

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<localleader>n', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>n', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', '<leader>p', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<localleader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  buf_set_keymap('n', '<localleader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)

  -- Set autocommands conditional on server_capabilities.
  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
    ]], false)
  end
end

local servers = {
  'gopls',
  'tsserver',
  'pyright',
  'sourcekit'
}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup { on_attach = on_attach }
end

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    virtual_text = false,
    signs = true,
    update_in_insert = false,
  }
)

-- }}} LSP

-- formatter {{{

vim.api.nvim_set_keymap('n', '<localleader>f', '<cmd>FormatWrite<CR>', { noremap = true, silent = true })

require('formatter').setup({
  logging = false,
  filetype = {
    go = {
      function()
        return {
          exe = "gofmt",
          args = {},
          stdin = true
        }
      end,
      function()
        return {
          exe = "goimports",
          args = {},
          stdin = true
        }
      end
    },
    javascript = {
      function()
        return {
          exe = "prettier",
          args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), '--single-quote'},
          stdin = true
        }
      end
    },
    typescript = {
      function()
        return {
          exe = "prettier",
          args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)},
          stdin = true
        }
      end
    },
    python = {
      function()
        return {
          exe = "black",
          args = {"-"},
          stdin = true
        }
      end
    }
  }
})

--- }}} Formatter

-- telescope {{{

require'telescope'.setup{
  defaults = {
    layout_config = {
      prompt_position = 'bottom',
      width = 80,
      height = 0.5,
    },
    prompt_prefix = '>',
    initial_mode = 'insert',
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰'},
    file_ignore_patterns = { 'dist/*', 'node_modules/*', 'venv/*' },
  }
}

-- }}} telescope

-- treesitter {{{

require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
  },
  indent = {
    enable = false
  },
}

-- }}} treesitter
