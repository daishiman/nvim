-- =====================================================
-- LSPサーバー設定
-- 各言語のLanguage Serverの設定とセットアップ
-- =====================================================

return {
  -- 追加のLSPサーバー設定プラグイン（空の設定でエラーを防ぐ）
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- =====================================================
      -- 補完機能の拡張
      -- =====================================================
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp-nvim-lsp")
      if has_cmp then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- =====================================================
      -- キーマップとハンドラー設定（on_attach関数）
      -- =====================================================
      local on_attach = function(client, bufnr)
        -- キーマップの設定は keymaps.lua で行われるため、
        -- ここでは追加の設定のみ

        -- フォーマット機能の制御（特定のLSPのみ有効化）
        local disable_formatting = {
          "tsserver",  -- TypeScript（prettierを使用）
          "jsonls",    -- JSON（prettierを使用）
          "html",      -- HTML（prettierを使用）
          "cssls",     -- CSS（prettierを使用）
        }

        for _, server in ipairs(disable_formatting) do
          if client.name == server then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end
        end
      end

      -- =====================================================
      -- LSPサーバーのセットアップ（Mason初期化後に実行）
      -- =====================================================
      vim.api.nvim_create_autocmd("User", {
        pattern = "MasonLspConfigReady",
        callback = function()
          local lspconfig = require("lspconfig")
          local mason_lspconfig = require("mason-lspconfig")

          -- LSPサーバーの個別設定
          local servers = {
            -- Lua
            lua_ls = {
              settings = {
                Lua = {
                  runtime = {
                    version = "LuaJIT",
                  },
                  diagnostics = {
                    globals = { "vim" },
                  },
                  workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                    checkThirdParty = false,
                  },
                  telemetry = {
                    enable = false,
                  },
                  format = {
                    enable = true,
                    defaultConfig = {
                      indent_style = "space",
                      indent_size = "2",
                    },
                  },
                },
              },
            },

            -- Rust
            rust_analyzer = {
              settings = {
                ["rust-analyzer"] = {
                  cargo = {
                    allFeatures = true,
                  },
                  checkOnSave = {
                    command = "clippy",
                  },
                  procMacro = {
                    enable = true,
                  },
                },
              },
            },

            -- Python
            pyright = {
              settings = {
                python = {
                  analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    useLibraryCodeForTypes = true,
                    typeCheckingMode = "basic",
                  },
                },
              },
            },

            -- TypeScript/JavaScript
            tsserver = {
              settings = {
                typescript = {
                  inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                  },
                },
                javascript = {
                  inlayHints = {
                    includeInlayParameterNameHints = "all",
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                  },
                },
              },
            },

            -- Go
            gopls = {
              settings = {
                gopls = {
                  gofumpt = true,
                  analyses = {
                    unusedparams = true,
                    shadow = true,
                  },
                  staticcheck = true,
                  usePlaceholders = true,
                  completeUnimported = true,
                },
              },
            },

            -- JSON
            jsonls = {
              settings = {
                json = {
                  schemas = require("schemastore").json.schemas(),
                  validate = { enable = true },
                },
              },
            },

            -- YAML
            yamlls = {
              settings = {
                yaml = {
                  schemas = require("schemastore").yaml.schemas(),
                  schemaStore = {
                    enable = false,
                    url = "",
                  },
                },
              },
            },

            -- その他のサーバー（デフォルト設定）
            bashls = {},
            cssls = {},
            html = {},
            vimls = {},
            dockerls = {},
          }

          -- LSPサーバーのセットアップ
          mason_lspconfig.setup_handlers({
            -- デフォルトハンドラー
            function(server_name)
              local server_config = servers[server_name] or {}
              server_config.capabilities = capabilities
              server_config.on_attach = on_attach

              lspconfig[server_name].setup(server_config)
            end,
          })
        end,
      })

      -- Mason設定完了後にイベント発火（手動発火）
      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyDone",
        callback = function()
          -- Mason関連プラグインが読み込まれた後にLSP設定を実行
          vim.schedule(function()
            vim.api.nvim_exec_autocmds("User", { pattern = "MasonLspConfigReady" })
          end)
        end,
      })
    end,
  },
}