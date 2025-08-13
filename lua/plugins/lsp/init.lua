-- lua/plugins/lsp/init.lua
return {
  -- Mason（LSPやツールの自動インストーラー）
  -- 最初にMasonをセットアップして、サーバーをインストール
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- Mason-LSPConfig（MasonとLSPの連携）
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "vtsls",              -- TypeScript/JavaScript
          "basedpyright",       -- Python（pyrightの高速版）
          "ruff",               -- Python リンター/フォーマッター
          "gopls",              -- Go
          "marksman",           -- Markdown
          "jsonls",             -- JSON
          "yamlls",             -- YAML
          "lua_ls",             -- Lua
          "html",               -- HTML
          "cssls",              -- CSS
          "tailwindcss",        -- Tailwind CSS
          "emmet_ls",           -- Emmet
          "dockerls",           -- Docker
          "docker_compose_language_service", -- Docker Compose
          "rust_analyzer",      -- Rust（オプション）
        },
        automatic_installation = true,
      })
    end,
  },

  -- Mason Tool Installer（追加ツールのインストール）
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettier",           -- JS/TS/CSS/HTML フォーマッター
          "stylua",             -- Lua フォーマッター
          "eslint_d",           -- JS/TS リンター
          "black",              -- Python フォーマッター
          "isort",              -- Python import ソーター
          "gofumpt",            -- Go フォーマッター
          "goimports",          -- Go import 管理
          "shfmt",              -- Shell フォーマッター
          "actionlint",         -- GitHub Actions リンター
          "markdownlint",       -- Markdown リンター
          "yamllint",           -- YAML リンター
        },
        auto_update = false,
        run_on_start = true,
        start_delay = 3000,
      })
    end,
  },

  -- LSP Config（言語サーバーの設定）
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "folke/neodev.nvim", opts = {} },
    },
    config = function()
      -- Neodevを先に設定（Neovim Lua開発用）
      require("neodev").setup()

      -- グローバルキーマップを設定
      require("plugins.lsp.keymaps")
    end,
  },

  -- SchemaStore（JSON/YAMLスキーマ）
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },

  -- LSP UI改善（オプション）
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },

  -- LSP シンボルアウトライン（オプション）
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = {
      { "<leader>lo", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" }
    },
    config = true,
  },
}