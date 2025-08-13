-- =====================================================
-- コードフォーマッター設定
-- コードを自動的に整形して読みやすく、統一されたスタイルにする
-- =====================================================

return {
  -- Conform.nvim：高速で柔軟なフォーマッター
  -- null-lsの後継として推奨される最新のフォーマッター管理ツール
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },  -- ファイル保存前に読み込み（保存時フォーマット用）
    cmd = { "ConformInfo" },    -- :ConformInfoコマンドで設定情報を表示

    -- キーマップ設定
    keys = {
      {
        "<leader>f",  -- Space + f でフォーマット実行
        function()
          require("conform").format({
            async = true,        -- 非同期実行（フリーズを防ぐ）
            lsp_fallback = true  -- フォーマッターがない場合はLSPのフォーマットを使用
          })
        end,
        mode = "",  -- 全モードで使用可能
        desc = "コードをフォーマット（整形）",
      },
    },

    config = function()
      require("conform").setup({
        -- =====================================================
        -- 言語別フォーマッター設定
        -- 各言語に対してどのフォーマッターを使うか定義
        -- =====================================================
        formatters_by_ft = {
          -- Web開発系（Prettierで統一）
          javascript = { "prettier" },       -- JavaScript
          typescript = { "prettier" },       -- TypeScript
          javascriptreact = { "prettier" },  -- React (JSX)
          typescriptreact = { "prettier" },  -- React (TSX)
          svelte = { "prettier" },          -- Svelte
          css = { "prettier" },             -- CSS
          html = { "prettier" },            -- HTML
          json = { "prettier" },            -- JSON
          yaml = { "prettier" },            -- YAML
          markdown = { "prettier" },        -- Markdown
          graphql = { "prettier" },         -- GraphQL

          -- 各言語専用のフォーマッター
          lua = { "stylua" },               -- Lua（Neovim設定用）

          -- Python（複数のフォーマッターを順番に適用）
          python = {
            "isort",  -- 1. import文を整理
            "black"   -- 2. コード全体を整形
          },

          -- Go（複数のフォーマッターを順番に適用）
          go = {
            "goimports",  -- 1. import文を整理
            "gofumpt"     -- 2. より厳格なフォーマット
          },

          rust = { "rustfmt" },  -- Rust公式フォーマッター
          sh = { "shfmt" },      -- シェルスクリプト

          -- 特殊設定：全ファイルタイプに適用
          ["_"] = { "trim_whitespace" },  -- 全てのファイルで行末の空白を削除
        },

        -- =====================================================
        -- 保存時の自動フォーマット設定
        -- ファイル保存時に自動的にフォーマットを実行
        -- =====================================================
        format_on_save = {
          timeout_ms = 500,      -- タイムアウト時間（500ミリ秒）
          lsp_fallback = true,   -- フォーマッターがない場合はLSPを使用
        },

        -- =====================================================
        -- 個別フォーマッターのカスタム設定
        -- 各フォーマッターの動作を細かく調整
        -- =====================================================
        formatters = {
          -- シェルスクリプトフォーマッター設定
          shfmt = {
            prepend_args = {
              "-i", "2"  -- インデントを2スペースに設定
            },
          },

          -- Prettier設定
          prettier = {
            prepend_args = {
              "--single-quote",      -- 文字列にシングルクォート使用（'）
              "--jsx-single-quote"   -- JSX内でもシングルクォート使用
            },
          },
        },
      })
    end,
  },
 }