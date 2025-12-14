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
		config = function()
			local config = {
				golang = {
					lsp = { "gopls", "golangci_lint_ls" },
					formatting = { "goimports" },
					code_actions = { "gomodifytags" },
				},
				python = {
					lsp = { "ruff", "pyright" },
				},
				rust = {
					lsp = { "rust_analyzer" },
				},
				web = {
					lsp = {
						"ts_ls",
						"cssls",
						"tailwindcss",
						html = {
							init_options = {
								provideFormatter = false,
							},
						},
					},
					formatting = { "prettier" },
				},
				elixir = {
					lsp = { "elixirls" },
				},
				lua = {
					lsp = {
						lua_ls = {
							settings = {
								Lua = {
									runtime = {
										version = "LuaJIT",
										path = vim.split(package.path, ";"),
									},
									diagnostics = {
										globals = { "vim" },
									},
									workspace = {
										library = vim.api.nvim_get_runtime_file("", true),
									},
									telemetry = {
										enable = false,
									},
								},
							},
						},
					},
					formatting = { "stylua" },
				},
				cxx = {
					lsp = {
						_sourcekit = {
							filetypes = { "swift", "objc", "objcpp" },
							capabilities = {
								workspace = {
									didChangeWatchedFiles = {
										dynamicRegistration = true,
									},
								},
							},
						},
						clangd = { filetypes = { "c", "cpp" } },
					},
				},
				devops = {
					lsp = { "terraformls" },
					formatting = { "terraform_fmt" },
				},
				sql = {
					lsp = {},
					formatting = {
						["pgformatter|pg_format"] = {
							extra_args = {
								"--spaces",
								2,
								"--wrap-limit",
								100,
								"--wrap-after",
								1,
								"--extra-function",
								vim.fn.expand("$XDG_CONFIG_HOME/pg_format/functions.lst"),
							},
						},
					},
				},
			}

			local install_lsps = {}
			for _, conf in pairs(config) do
				for key, value in pairs(conf.lsp) do
					local lsp
					local skip_install = false

					if type(key) == "number" then
						lsp = value
					else
						lsp = key
					end

					-- If the LSP name starts with "_", do not install it via mason.
					if lsp:sub(1, 1) == "_" then
						lsp = lsp:sub(2)
						skip_install = true
					end

					vim.lsp.enable(lsp)

					if not skip_install then
						table.insert(install_lsps, lsp)
					end

					if type(value) == "table" then
						vim.lsp.config[key] = value
					end
				end
			end

			local null_ls = require("null-ls")
			local mason_tools = {}
			local null_ls_sources = {}
			for _, conf in pairs(config) do
				for key, exes in pairs(conf) do
					if key ~= "lsp" then
						for k, v in pairs(exes) do
							local mason_name, null_ls_name

							if type(k) == "string" then
								local pipe_pos = string.find(k, "|")
								if pipe_pos then
									mason_name = string.sub(k, 1, pipe_pos - 1) -- everything before "|"
									null_ls_name = string.sub(k, pipe_pos + 1) -- everything after "|"
								else
									mason_name = k
									null_ls_name = k
								end
							else
								null_ls_name = v
								mason_name = v
							end

							table.insert(mason_tools, mason_name)
							if type(v) == "table" then
								table.insert(null_ls_sources, null_ls.builtins[key][null_ls_name].with(v))
							else
								table.insert(null_ls_sources, null_ls.builtins[key][null_ls_name])
							end
						end
					end
				end
			end

			require("mason").setup()
			require("mason-lspconfig").setup({ ensure_installed = install_lsps })
			require("mason-null-ls").setup({ ensure_installed = mason_tools })
			null_ls.setup({ sources = null_ls_sources })

			vim.lsp.config("*", {
				capabilities = require("cmp_nvim_lsp").default_capabilities(
					vim.lsp.protocol.make_client_capabilities()
				),
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("global.lsp", { clear = true }),
				callback = function(args)
					-- local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
					local bufnr = args.buf

					-- Diagnostics window borders.
					local border = "rounded"

					vim.diagnostic.config({
						float = { border = border },
						virtual_text = false,
						signs = true,
					})

					-- Mappings.
					local bufopts = { noremap = true, silent = true, buffer = bufnr }
					vim.keymap.set("n", "K", function() vim.lsp.buf.hover { border = border } end, bufopts)
					vim.keymap.set("n", "<C-k>", function() vim.lsp.buf.signature_help { border = border } end, bufopts)
					vim.keymap.set("n", "<localleader>d", vim.lsp.buf.type_definition, bufopts)
					vim.keymap.set("n", "<localleader>r", vim.lsp.buf.rename, bufopts)
					vim.keymap.set("n", "<localleader>a", vim.lsp.buf.code_action, bufopts)
					vim.keymap.set("n", "<localleader>f", function()
						vim.lsp.buf.format({ async = false })
					end, bufopts)
					vim.keymap.set("n", "<localleader>e", vim.diagnostic.open_float, bufopts)
					vim.keymap.set("n", "gn", function()
						vim.diagnostic.jump({ count = 1, float = true })
					end, bufopts)
					vim.keymap.set("n", "gp", function()
						vim.diagnostic.jump({ count = -1, float = true })
					end, bufopts)
				end,
			})
		end,
	},
}
