-- =====================================================
-- デバッグプラグイン設定
-- VSCodeのようなデバッグ機能をNeovimで実現
-- =====================================================

return {
  -- nvim-dap：デバッグ機能の中核
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      -- デバッグUI（変数表示、ブレークポイント管理など）
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",  -- 非同期I/Oライブラリ（UIの依存）

      -- 仮想テキスト表示（変数の値を行末に表示）
      "theHamsta/nvim-dap-virtual-text",

      -- 言語別デバッグアダプター
      "mfussenegger/nvim-dap-python",  -- Python用
      "leoluz/nvim-dap-go",            -- Go言語用
      "jbyuki/one-small-step-for-vimkind",  -- Lua用（Neovim設定のデバッグに便利）

      -- Mason統合（デバッガーの自動インストール）
      "jay-babu/mason-nvim-dap.nvim",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- =====================================================
      -- Mason DAP設定：デバッガーの自動インストール
      -- =====================================================
      require("mason-nvim-dap").setup({
        ensure_installed = {
          "python",     -- Pythonデバッガー
          "delve",      -- Go言語デバッガー
          "node2",      -- Node.jsデバッガー
          "chrome",     -- Chromeデバッガー（フロントエンド）
          "firefox",    -- Firefoxデバッガー（フロントエンド）
        },
        automatic_installation = true,  -- 必要なデバッガーを自動でインストール
      })

      -- =====================================================
      -- デバッグUI設定：VSCodeのようなデバッグパネル
      -- =====================================================
      dapui.setup({
        -- アイコン設定
        icons = {
          expanded = "",      -- 展開時のアイコン
          collapsed = "",     -- 折りたたみ時のアイコン
          current_frame = ""  -- 現在のフレームアイコン
        },

        -- UIパネル内の操作キー
        mappings = {
          expand = { "<CR>", "<2-LeftMouse>" },  -- Enter or ダブルクリックで展開
          open = "o",         -- oで開く
          remove = "d",       -- dで削除
          edit = "e",         -- eで編集
          repl = "r",         -- rでREPL（対話型実行環境）
          toggle = "t",       -- tで切り替え
        },

        -- レイアウト設定（パネルの配置）
        layouts = {
          {
            -- 左側のパネル（変数、ブレークポイントなど）
            elements = {
              { id = "scopes", size = 0.25 },      -- スコープ（変数の値）25%
              { id = "breakpoints", size = 0.25 }, -- ブレークポイント一覧 25%
              { id = "stacks", size = 0.25 },      -- コールスタック 25%
              { id = "watches", size = 0.25 },     -- ウォッチ式 25%
            },
            size = 40,          -- 幅40文字
            position = "left",  -- 左側に配置
          },
          {
            -- 下部のパネル（REPL、コンソール）
            elements = {
              { id = "repl", size = 0.5 },    -- REPL（対話型実行）50%
              { id = "console", size = 0.5 },  -- コンソール出力 50%
            },
            size = 10,           -- 高さ10行
            position = "bottom", -- 下部に配置
          },
        },
      })

      -- =====================================================
      -- 仮想テキスト設定：変数の値を行末に表示
      -- =====================================================
      require("nvim-dap-virtual-text").setup({
        enabled = true,                        -- 機能を有効化
        enabled_commands = true,               -- コマンドを有効化
        highlight_changed_variables = true,    -- 変更された変数をハイライト
        highlight_new_as_changed = false,      -- 新規変数を変更扱いしない
        show_stop_reason = true,               -- 停止理由を表示
        commented = false,                     -- コメントスタイルで表示しない
        only_first_definition = true,          -- 最初の定義のみ表示
        all_references = false,                -- 全参照を表示しない
        filter_references_pattern = "<module", -- モジュール参照をフィルタ
        virt_text_pos = "eol",                -- 行末（end of line）に表示
        all_frames = false,                    -- 全フレーム表示しない
        virt_lines = false,                    -- 仮想行を使用しない
        virt_text_win_col = nil,              -- ウィンドウ列指定なし
      })

      -- =====================================================
      -- Python設定
      -- =====================================================
      require("dap-python").setup("python")  -- システムのPythonを使用

      -- =====================================================
      -- Go設定
      -- =====================================================
      require("dap-go").setup()  -- デフォルト設定でセットアップ

      -- =====================================================
      -- JavaScript/TypeScript設定
      -- =====================================================
      -- Node.jsデバッグアダプターの設定
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",  -- 動的にポートを割り当て
        executable = {
          command = "node",
          args = {
            -- Masonでインストールしたデバッグアダプターのパスを取得
            require("mason-registry").get_package("js-debug-adapter"):get_install_path()
              .. "/js-debug/src/dapDebugServer.js",
            "${port}",  -- ポート番号を引数として渡す
          },
        },
      }

      -- JavaScriptのデバッグ設定
      dap.configurations.javascript = {
        {
          type = "pwa-node",        -- PWA Node アダプターを使用
          request = "launch",       -- プログラムを起動してデバッグ
          name = "Launch file",     -- 設定名
          program = "${file}",      -- 現在開いているファイルをデバッグ
          cwd = "${workspaceFolder}", -- 作業ディレクトリ
        },
      }

      -- TypeScriptも同じ設定を使用
      dap.configurations.typescript = dap.configurations.javascript

      -- =====================================================
      -- UIの自動開閉設定
      -- =====================================================
      -- デバッグ開始時にUIを自動で開く
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end

      -- デバッグ終了時にUIを自動で閉じる
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end

      -- プログラム終了時にUIを自動で閉じる
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- =====================================================
      -- キーマップ設定：VSCodeと同じファンクションキー
      -- =====================================================

      -- デバッグ制御（VSCodeと同じキー配置）
      vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "デバッグ開始/継続（VSCodeと同じ）" })
      vim.keymap.set("n", "<F10>", function() dap.step_over() end, { desc = "ステップオーバー（関数を飛ばす）" })
      vim.keymap.set("n", "<F11>", function() dap.step_into() end, { desc = "ステップイン（関数内に入る）" })
      vim.keymap.set("n", "<F12>", function() dap.step_out() end, { desc = "ステップアウト（関数から出る）" })

      -- ブレークポイント操作
      vim.keymap.set("n", "<leader>db", function() dap.toggle_breakpoint() end, { desc = "ブレークポイントの設置/削除" })
      vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))  -- 条件を入力
      end, { desc = "条件付きブレークポイント（例：i > 10）" })
      vim.keymap.set("n", "<leader>dlp", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))  -- ログメッセージを入力
      end, { desc = "ログポイント（停止せずにログ出力）" })

      -- デバッグツール
      vim.keymap.set("n", "<leader>dr", function() dap.repl.open() end, { desc = "REPL（対話型実行環境）を開く" })
      vim.keymap.set("n", "<leader>dl", function() dap.run_last() end, { desc = "最後のデバッグ設定で再実行" })
      vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { desc = "デバッグUIの表示/非表示" })

      -- 変数の評価
      vim.keymap.set("n", "<leader>de", function() dapui.eval() end, { desc = "カーソル下の変数を評価" })
      vim.keymap.set("v", "<leader>de", function() dapui.eval() end, { desc = "選択した式を評価" })
    end,
  },
 }