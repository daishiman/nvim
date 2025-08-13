-- =====================================================
-- AI関連の設定
-- Claude Code/Cursorと併用するための軽量設定
-- =====================================================

return {
  -- =====================================================
  -- オプション1: Codeium（無料・軽量なAI補完）
  -- Claude Code/Cursorのバックアップとして使用
  -- 不要な場合は enabled = false に設定
  -- =====================================================
  {
    "Exafunction/codeium.vim",
    enabled = false,  -- デフォルトで無効（必要なら true に変更）
    event = "InsertEnter",  -- 挿入モードで遅延読み込み
    config = function()
      -- 軽量な設定（最小限のキーバインド）
      vim.g.codeium_disable_bindings = 1
      vim.g.codeium_manual = false  -- 自動提案を有効化

      -- Tab キーで提案を受け入れる（VSCode風）
      vim.keymap.set("i", "<Tab>", function()
        if vim.fn["codeium#Accept"]() ~= "" then
          return vim.fn["codeium#Accept"]()
        else
          return "<Tab>"
        end
      end, { expr = true, silent = true })

      -- Alt+] で次の提案
      vim.keymap.set("i", "<M-]>", function()
        return vim.fn["codeium#CycleCompletions"](1)
      end, { expr = true, silent = true })

      -- Alt+[ で前の提案
      vim.keymap.set("i", "<M-[>", function()
        return vim.fn["codeium#CycleCompletions"](-1)
      end, { expr = true, silent = true })

      -- Escで提案をクリア
      vim.keymap.set("i", "<C-e>", function()
        return vim.fn["codeium#Clear"]()
      end, { expr = true, silent = true })

      -- ステータス表示用の関数
      vim.g.codeium_status = function()
        return vim.fn["codeium#GetStatusString"]()
      end
    end,
  },

  -- =====================================================
  -- オプション2: ファイル連携ツール
  -- Claude Code/Cursorで編集したファイルを自動リロード
  -- =====================================================
  {
    "djoshea/vim-autoread",
    enabled = true,
    event = "VeryLazy",
    config = function()
      -- 外部エディタでの変更を自動検出
      vim.o.autoread = true

      -- フォーカス取得時とバッファ切り替え時に自動リロード
      vim.api.nvim_create_autocmd(
        { "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" },
        {
          pattern = "*",
          command = "if mode() != 'c' | checktime | endif",
        }
      )

      -- ファイル変更通知
      vim.api.nvim_create_autocmd("FileChangedShellPost", {
        pattern = "*",
        callback = function()
          vim.notify("ファイルが外部で変更されました", vim.log.levels.INFO)
        end,
      })
    end,
  },

  -- =====================================================
  -- オプション3: クリップボード連携強化
  -- エディタ間のコピペを改善
  -- =====================================================
  {
    "ojroques/nvim-osc52",
    enabled = true,
    event = "VeryLazy",
    config = function()
      require("osc52").setup({
        max_length = 0,      -- 制限なし
        silent = false,      -- エラーを表示
        trim = false,        -- 空白を削除しない
      })

      -- クリップボードへのコピー
      vim.keymap.set("n", "<leader>y", require("osc52").copy_operator, { expr = true })
      vim.keymap.set("n", "<leader>yy", "<leader>y_", { remap = true })
      vim.keymap.set("v", "<leader>y", require("osc52").copy_visual)
    end,
  },

  -- =====================================================
  -- オプション4: プロジェクト管理
  -- Claude Code/Cursorとプロジェクトを共有
  -- =====================================================
  {
    "ahmedkhalf/project.nvim",
    enabled = true,
    event = "VeryLazy",
    config = function()
      require("project_nvim").setup({
        -- プロジェクト検出方法
        detection_methods = { "pattern", "lsp" },

        -- プロジェクトルートのパターン
        patterns = {
          ".git",
          "_darcs",
          ".hg",
          ".bzr",
          ".svn",
          "Makefile",
          "package.json",
          "Cargo.toml",
          "go.mod",
          "requirements.txt",
          "pyproject.toml",
        },

        -- 無視するディレクトリ
        exclude_dirs = {
          "~",
          "~/Downloads",
          "/tmp",
        },

        -- プロジェクト変更時の通知
        silent_chdir = false,

        -- データパス（Claude Code/Cursorと共有可能）
        datapath = vim.fn.stdpath("data"),
      })

      -- キーマップ
      vim.keymap.set("n", "<leader>fp", "<cmd>Telescope projects<cr>",
        { desc = "プロジェクト一覧" })
    end,
  },

  -- =====================================================
  -- オプション5: セッション管理
  -- エディタ間でセッションを保持
  -- =====================================================
  {
    "rmagatti/auto-session",
    enabled = true,
    lazy = false,
    config = function()
      require("auto-session").setup({
        log_level = "error",
        auto_session_suppress_dirs = { "~/", "~/Downloads", "/" },
        auto_session_use_git_branch = true,

        -- セッション保存前の処理
        pre_save_cmds = {
          -- 不要なバッファを閉じる
          function()
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              local name = vim.api.nvim_buf_get_name(buf)
              if name:match("^term://") or name == "" then
                vim.api.nvim_buf_delete(buf, { force = true })
              end
            end
          end,
        },
      })

      -- キーマップ
      vim.keymap.set("n", "<leader>ss", "<cmd>SessionSave<cr>",
        { desc = "セッション保存" })
      vim.keymap.set("n", "<leader>sr", "<cmd>SessionRestore<cr>",
        { desc = "セッション復元" })
      vim.keymap.set("n", "<leader>sd", "<cmd>SessionDelete<cr>",
        { desc = "セッション削除" })
    end,
  },

  -- =====================================================
  -- オプション6: ファイル同期用のコマンド
  -- Claude Code/Cursorとの連携用
  -- =====================================================
  {
    "klen/nvim-config-local",
    enabled = true,
    event = "VeryLazy",
    config = function()
      require("config-local").setup({
        -- プロジェクトローカル設定ファイル
        config_files = { ".nvim.lua", ".nvimrc", ".exrc" },

        -- ハッシュ化されたファイル名を使用
        hashfile = vim.fn.stdpath("data") .. "/config-local",

        -- 自動コマンドパターン
        autocommands_create = true,
        commands_create = true,
        silent = false,

        -- ファイル検索深度
        lookup_parents = true,
      })
    end,
  },
}

-- =====================================================
-- 使用方法とTips
-- =====================================================
-- 1. Claude Code/Cursorで編集中のファイルはNeovimで自動リロード
-- 2. プロジェクト管理で同じプロジェクトを簡単に開ける
-- 3. セッション管理で作業状態を保持
-- 4. OSC52でSSH経由でもクリップボード共有可能
--
-- 推奨ワークフロー：
-- - 複雑なリファクタリング: Claude Code/Cursor
-- - 素早い編集とナビゲーション: Neovim
-- - AI支援が必要な場合: Claude Code/Cursor に切り替え
-- =====================================================