-- =====================================================
-- リンター（エラーチェック）とエラー表示設定
-- コードの問題点を自動的に検出して表示
-- =====================================================

return {
  -- =====================================================
  -- nvim-lint：非同期リンター
  -- コードの問題をリアルタイムで検出（構文エラー、スタイル違反など）
  -- =====================================================
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },  -- ファイルを開く前/新規作成時に読み込み
    config = function()
      local lint = require("lint")

      -- =====================================================
      -- 言語別リンター設定
      -- 各言語でどのリンターを使用するか定義
      -- =====================================================
      lint.linters_by_ft = {
        -- JavaScript/TypeScript系（ESLintの高速版を使用）
        javascript = { "eslint_d" },       -- JavaScript
        typescript = { "eslint_d" },       -- TypeScript
        javascriptreact = { "eslint_d" },  -- React JSX
        typescriptreact = { "eslint_d" },  -- React TSX
        svelte = { "eslint_d" },          -- Svelte

        -- Python（2つのリンターを併用）
        python = {
          "pylint",  -- 伝統的で詳細なチェック
          "ruff"     -- 高速で最新のチェック
        },

        -- その他の言語
        markdown = { "markdownlint" },     -- Markdown構文チェック
        yaml = { "yamllint" },            -- YAML構文チェック
        json = { "jsonlint" },            -- JSON構文チェック
        dockerfile = { "hadolint" },      -- Dockerfileベストプラクティスチェック
        sh = { "shellcheck" },            -- シェルスクリプトの問題検出
        go = { "golangcilint" },          -- Go言語の総合リンター
      }

      -- =====================================================
      -- 自動リント実行の設定
      -- 特定のタイミングで自動的にリントを実行
      -- =====================================================
      local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })  -- グループ作成
      vim.api.nvim_create_autocmd(
        {
          "BufEnter",        -- バッファに入った時
          "BufWritePost",    -- ファイル保存後
          "InsertLeave"      -- 挿入モードを抜けた時
        },
        {
          group = lint_augroup,
          callback = function()
            lint.try_lint()  -- リントを実行（エラーがあっても続行）
          end,
        }
      )

      -- 手動リント実行のキーマップ
      vim.keymap.set("n", "<leader>l", function()
        lint.try_lint()
      end, { desc = "今すぐリントを実行" })
    end,
  },

  -- =====================================================
  -- Trouble.nvim：診断結果の見やすい表示
  -- エラーや警告を整理して一覧表示
  -- =====================================================
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },  -- アイコン表示用
    config = function()
      require("trouble").setup({
        -- ウィンドウ設定
        position = "bottom",              -- 画面下部に表示
        height = 10,                      -- 高さ10行
        icons = true,                     -- アイコンを表示
        mode = "workspace_diagnostics",  -- デフォルトモード（ワークスペース全体の診断）

        -- 折りたたみアイコン
        fold_open = "",                 -- 展開時のアイコン
        fold_closed = "",               -- 折りたたみ時のアイコン

        -- グループ化とレイアウト
        group = true,                     -- ファイル別にグループ化
        padding = true,                   -- パディング追加

        -- 操作キー設定（Trouble内で使用）
        action_keys = {
          close = "q",                    -- qで閉じる
          cancel = "<esc>",               -- Escでキャンセル
          refresh = "r",                  -- rで更新
          jump = { "<cr>", "<tab>" },     -- EnterまたはTabでジャンプ
          open_split = { "<c-x>" },       -- Ctrl+xで水平分割して開く
          open_vsplit = { "<c-v>" },      -- Ctrl+vで垂直分割して開く
          open_tab = { "<c-t>" },         -- Ctrl+tでタブで開く
          jump_close = { "o" },           -- oでジャンプして閉じる
          toggle_mode = "m",              -- mでモード切り替え
          toggle_preview = "P",           -- Pでプレビュー切り替え
          hover = "K",                    -- Kでホバー情報
          preview = "p",                  -- pでプレビュー
          close_folds = { "zM", "zm" },   -- 全て折りたたむ
          open_folds = { "zR", "zr" },    -- 全て展開
          toggle_fold = { "zA", "za" },   -- 折りたたみ切り替え
          previous = "k",                 -- k前の項目へ
          next = "j",                     -- j次の項目へ
        },

        -- 表示設定
        indent_lines = true,              -- インデント線を表示
        auto_open = false,                -- 自動で開かない
        auto_close = false,               -- 自動で閉じない
        auto_preview = true,              -- 自動プレビュー有効
        auto_fold = false,                -- 自動折りたたみ無効

        -- 自動ジャンプ設定
        auto_jump = { "lsp_definitions" }, -- 定義へは自動ジャンプ

        -- エラーレベル別のアイコン
        signs = {
          error = "",        -- エラーアイコン
          warning = "",      -- 警告アイコン
          hint = "",         -- ヒントアイコン
          information = "",  -- 情報アイコン
          other = "﫠",       -- その他のアイコン
        },

        use_diagnostic_signs = false,    -- LSPの診断記号を使用しない（独自アイコン使用）
      })

      -- =====================================================
      -- Troubleのキーマップ設定
      -- Space + x で各種診断表示
      -- =====================================================

      -- 基本操作
      vim.keymap.set("n", "<leader>xx", "<cmd>TroubleToggle<CR>",
        { desc = "診断リストの表示/非表示" })

      -- 診断の範囲別表示
      vim.keymap.set("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<CR>",
        { desc = "プロジェクト全体の問題を表示" })
      vim.keymap.set("n", "<leader>xd", "<cmd>TroubleToggle document_diagnostics<CR>",
        { desc = "現在のファイルの問題を表示" })

      -- Vimの標準リスト
      vim.keymap.set("n", "<leader>xl", "<cmd>TroubleToggle loclist<CR>",
        { desc = "ロケーションリスト（現在のウィンドウ用）" })
      vim.keymap.set("n", "<leader>xq", "<cmd>TroubleToggle quickfix<CR>",
        { desc = "クイックフィックス（グローバル）" })

      -- LSP機能
      vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<CR>",
        { desc = "この変数/関数が使われている場所一覧" })
    end,
  },
 }