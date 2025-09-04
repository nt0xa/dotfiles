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
			local config = {
				golang = {
					lsp = { "gopls", "golangci_lint_ls" },
					formatting = { "goimports" },
					code_actions = { "gomodifytags" },
				},
				rust = {
					lsp = { "rust_analyzer" },
				},
				python = {
					lsp = { "ruff", "pyright" },
				},
				css = {
					lsp = { "cssls", "tailwindcss" },
				},
				typescript = {
					lsp = { "ts_ls" },
					formatting = { "prettier" },
				},
				html = {
					lsp = { "html" },
				},
				terraform = {
					lsp = { "terraformls" },
					formatting = { "terraform_fmt" },
				},
				elixir = {
					lsp = { "elixirls" },
				},
				lua = {
					lsp = { "lua_ls" },
					formatting = { "stylua" },
				},
				c = {
					lsp = { "clangd" },
				},
			}

			local lsps = {}
			for lang, conf in pairs(config) do
				for _, lsp in pairs(conf.lsp) do
					table.insert(lsps, lsp)
					vim.lsp.enable(lsp)
				end
			end

			local null_ls = require("null-ls")
			local tools = {}
			local sources = {}
			for _, conf in pairs(config) do
				for key, exes in pairs(conf) do
					if key ~= "lsp" then
						for _, exe in pairs(exes) do
							table.insert(tools, exe)
							table.insert(sources, null_ls.builtins[key][exe])
						end
					end
				end
			end

			require("mason").setup()
			require("mason-lspconfig").setup({ ensure_installed = lsps })
			require("mason-null-ls").setup({ ensure_installed = tools })
			null_ls.setup({ sources = sources })

			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(
					vim.lsp.protocol.make_client_capabilities()
				),
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("global.lsp", { clear = true }),
				callback = function(args)
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
					local bufnr = args.buf

					-- Diagnostics window borders.
					local border = "rounded"

					vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
						border = border,
					})

					vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
						border = border,
					})

					vim.diagnostic.config({
						float = { border = border },
						virtual_text = false,
						signs = true,
					})

					-- Mappings.
					-- See `:help vim.lsp.*` for documentation on any of the below functions
					local bufopts = { noremap = true, silent = true, buffer = bufnr }
					vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
					vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
					vim.keymap.set("n", "<localleader>d", vim.lsp.buf.type_definition, bufopts)
					vim.keymap.set("n", "<localleader>r", vim.lsp.buf.rename, bufopts)
					vim.keymap.set("n", "<localleader>a", vim.lsp.buf.code_action, bufopts)
					vim.keymap.set("n", "<localleader>f", function()
						vim.lsp.buf.format({ async = false })
					end, bufopts)
					vim.keymap.set("n", "<localleader>e", vim.diagnostic.open_float, bufopts)
					vim.keymap.set("n", "gn", vim.diagnostic.goto_next, bufopts)
					vim.keymap.set("n", "gp", vim.diagnostic.goto_prev, bufopts)
				end,
			})
		end,
	},
}
