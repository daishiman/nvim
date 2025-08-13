-- =====================================================
-- Git関連プラグイン設定
-- Git操作を効率化し、変更履歴を可視化する
-- =====================================================
return {
  -- =====================================================
  -- Gitsigns：Git差分を左端に表示
  -- リアルタイムでGitの変更状態を可視化し、
  -- バッファ内でGit操作を可能にする
  -- =====================================================
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },  -- ファイルを開く前に読み込み
    config = function()
      require("gitsigns").setup({
        -- =====================================================
        -- 差分表示の記号設定
        -- サインカラムに表示される記号をカスタマイズ
        -- =====================================================
        signs = {
          add = { text = "│" },          -- 新規追加された行
          change = { text = "│" },       -- 変更された行
          delete = { text = "_" },       -- 削除された行
          topdelete = { text = "‾" },    -- ファイル先頭での削除
          changedelete = { text = "~" }, -- 変更と削除が混在する箇所
          untracked = { text = "┆" },    -- Gitで追跡されていないファイル
        },

        -- =====================================================
        -- 表示設定
        -- Gitsignsの表示方法を制御
        -- =====================================================
        signcolumn = true,     -- 左端の記号列を表示（Git差分を表示）
        numhl = false,         -- 行番号のハイライト（パフォーマンスのため無効）
        linehl = false,        -- 行全体のハイライト（視覚的にうるさいので無効）
        word_diff = false,     -- 単語単位の差分（詳細すぎるので無効）

        -- =====================================================
        -- ファイル監視設定
        -- Gitディレクトリの変更を監視
        -- =====================================================
        watch_gitdir = {
          interval = 1000,     -- 1秒ごとにGitディレクトリをチェック
          follow_files = true, -- ファイル移動を追跡（リネーム対応）
        },

        -- =====================================================
        -- Blame表示設定
        -- 各行の最終更新者と日時を表示
        -- =====================================================
        attach_to_untracked = true,  -- 未追跡ファイルにもGitsignsを適用
        current_line_blame = true,   -- 現在行のblame情報を自動表示
        current_line_blame_opts = {
          virt_text = true,          -- 仮想テキストとして表示（実際のファイルには影響しない）
          virt_text_pos = "eol",     -- 行末（end of line）に表示
          delay = 1000,              -- カーソル停止から1秒後に表示
          ignore_whitespace = false, -- 空白の変更も考慮（厳密な追跡）
        },
        -- Blame表示のフォーマット：作者、日付、コミットメッセージ
        current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",

        -- =====================================================
        -- パフォーマンス設定
        -- 大規模ファイルでの動作を最適化
        -- =====================================================
        sign_priority = 6,           -- 他のプラグインとの記号優先度
        update_debounce = 100,       -- 更新の遅延（ミリ秒）- 頻繁な更新を防ぐ
        status_formatter = nil,      -- ステータス表示形式（デフォルト使用）
        max_file_length = 40000,     -- 40000行以上のファイルは処理しない（パフォーマンス保護）

        -- =====================================================
        -- プレビューウィンドウの設定
        -- 変更内容のプレビュー表示設定
        -- =====================================================
        preview_config = {
          border = "single",         -- 枠線スタイル（single/double/rounded）
          style = "minimal",         -- 最小限のスタイル（余計な装飾なし）
          relative = "cursor",       -- カーソル位置に相対的に表示
          row = 0,                   -- 行オフセット（カーソルからの距離）
          col = 1,                   -- 列オフセット（カーソルからの距離）
        },

        -- =====================================================
        -- yadm設定
        -- dotfile管理ツールyadmのサポート（未使用）
        -- =====================================================
        yadm = {
          enable = false,            -- yadmサポートは無効
        },

        -- =====================================================
        -- キーマップ設定
        -- Gitsignsの各機能へのショートカットキー設定
        -- =====================================================
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          -- キーマップ設定用のヘルパー関数
          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr  -- 現在のバッファにのみ適用
            vim.keymap.set(mode, l, r, opts)
          end

          -- =====================================================
          -- ナビゲーション：変更箇所間の移動
          -- =====================================================
          -- ]c: 次の変更箇所へジャンプ
          map("n", "]c", function()
            if vim.wo.diff then return "]c" end  -- diffモードでは通常の動作
            vim.schedule(function() gs.next_hunk() end)  -- 非同期で次の変更へ
            return "<Ignore>"
          end, { expr = true, desc = "次の変更へジャンプ" })

          -- [c: 前の変更箇所へジャンプ
          map("n", "[c", function()
            if vim.wo.diff then return "[c" end  -- diffモードでは通常の動作
            vim.schedule(function() gs.prev_hunk() end)  -- 非同期で前の変更へ
            return "<Ignore>"
          end, { expr = true, desc = "前の変更へジャンプ" })

          -- =====================================================
          -- ステージング操作：Gitのステージエリアへの追加/削除
          -- =====================================================
          map("n", "<leader>hs", gs.stage_hunk, { desc = "現在の変更をステージに追加" })
          map("n", "<leader>hr", gs.reset_hunk, { desc = "現在の変更を元に戻す" })
          map("v", "<leader>hs", function() gs.stage_hunk {vim.fn.line("."), vim.fn.line("v")} end, { desc = "選択範囲をステージ" })
          map("v", "<leader>hr", function() gs.reset_hunk {vim.fn.line("."), vim.fn.line("v")} end, { desc = "選択範囲をリセット" })
          map("n", "<leader>hS", gs.stage_buffer, { desc = "ファイル全体をステージ" })
          map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "直前のステージ操作を取り消し" })
          map("n", "<leader>hR", gs.reset_buffer, { desc = "ファイル全体の変更をリセット" })

          -- =====================================================
          -- 情報表示：変更内容やBlame情報の表示
          -- =====================================================
          map("n", "<leader>hp", gs.preview_hunk, { desc = "変更内容をフローティングウィンドウでプレビュー" })
          map("n", "<leader>hb", function() gs.blame_line{full=true} end, { desc = "現在行の詳細なBlame情報を表示" })
          map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Blame表示の有効/無効を切り替え" })
          map("n", "<leader>hd", gs.diffthis, { desc = "現在のファイルの差分を表示" })
          map("n", "<leader>hD", function() gs.diffthis("~") end, { desc = "前のコミットとの差分を表示" })
          map("n", "<leader>td", gs.toggle_deleted, { desc = "削除された行の表示を切り替え" })

          -- =====================================================
          -- テキストオブジェクト：変更箇所を選択可能にする
          -- =====================================================
          map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "変更箇所をテキストオブジェクトとして選択" })
        end,
      })
    end,
  },

  -- =====================================================
  -- Neogit：Magitスタイルのgitインターフェース
  -- Emacsの人気Git拡張機能Magitに触発された
  -- 包括的なGit操作インターフェース
  -- =====================================================
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",      -- Lua関数ライブラリ（必須）
      "sindrets/diffview.nvim",     -- 高機能な差分ビューワー
      "ibhagwan/fzf-lua",          -- 高速ファジーファインダー
    },
    config = function()
      require("neogit").setup({
        -- =====================================================
        -- 表示設定
        -- Neogitの見た目と動作をカスタマイズ
        -- =====================================================
        disable_signs = false,                   -- サイン表示を有効
        disable_hint = false,                    -- ヒント表示を有効
        disable_context_highlighting = false,    -- コンテキストハイライトを有効
        disable_commit_confirmation = false,     -- コミット確認を有効（誤操作防止）
        auto_refresh = true,                     -- 自動的に状態を更新
        sort_branches = "-committerdate",        -- ブランチを最新コミット日でソート

        -- =====================================================
        -- ウィンドウ設定
        -- Neogitの表示方法
        -- =====================================================
        kind = "tab",                            -- 新しいタブで開く（tab/split/vsplit/floating）
        console_timeout = 2000,                  -- コンソール出力のタイムアウト（2秒）
        auto_show_console = true,                -- コマンド実行時にコンソールを自動表示
        remember_settings = true,                -- 設定を記憶（次回起動時に復元）
        use_magit_keybindings = false,           -- Magitのキーバインド使用しない（Vim風を維持）

        -- =====================================================
        -- 統合設定
        -- 他のプラグインとの連携
        -- =====================================================
        integrations = {
          diffview = true,                       -- Diffviewとの統合を有効
        },
      })

      -- =====================================================
      -- グローバルキーマップ
      -- どこからでもNeogitの機能にアクセス
      -- =====================================================
      vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<CR>", { desc = "Neogitメインパネルを開く" })
      vim.keymap.set("n", "<leader>gc", "<cmd>Neogit commit<CR>", { desc = "コミット画面を開く" })
      vim.keymap.set("n", "<leader>gp", "<cmd>Neogit push<CR>", { desc = "プッシュ操作" })
      vim.keymap.set("n", "<leader>gl", "<cmd>Neogit pull<CR>", { desc = "プル操作" })
    end,
  },

  -- =====================================================
  -- Diffview：高機能な差分表示
  -- ファイルの変更履歴を視覚的に確認
  -- =====================================================
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",   -- Lua関数ライブラリ（必須）
    -- 遅延読み込み：以下のコマンドが呼ばれた時のみ読み込む
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = function()
      require("diffview").setup({
        -- =====================================================
        -- 表示設定
        -- 差分表示の見た目をカスタマイズ
        -- =====================================================
        enhanced_diff_hl = true,              -- 拡張差分ハイライト（より見やすい色分け）
        use_icons = true,                     -- アイコンを使用（視覚的に分かりやすく）
        icons = {
          folder_closed = "",                -- 閉じたフォルダのアイコン
          folder_open = "",                  -- 開いたフォルダのアイコン
        },
      })

      -- =====================================================
      -- キーマップ設定
      -- Diffviewへのショートカット
      -- =====================================================
      vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewOpen<CR>", { desc = "差分ビューを開く（作業ツリーの変更）" })
      vim.keymap.set("n", "<leader>gh", "<cmd>DiffviewFileHistory<CR>", { desc = "ファイル履歴を表示（過去のコミット）" })
    end,
  },

  -- =====================================================
  -- Git blame：行ごとの最終更新者表示
  -- 各行を誰がいつ変更したかを確認
  -- =====================================================
  {
    "f-person/git-blame.nvim",
    event = "BufRead",                        -- ファイル読み込み時に遅延読み込み
    config = function()
      -- =====================================================
      -- 基本設定
      -- Git blameの動作を制御
      -- =====================================================
      vim.g.gitblame_enabled = 0              -- デフォルトでは無効（必要時のみ有効化）
      -- Blame表示フォーマット：コミットメッセージ • 日付 • 作者名
      vim.g.gitblame_message_template = "<summary> • <date> • <author>"
      vim.g.gitblame_date_format = "%Y-%m-%d" -- 日付形式：年-月-日

      -- =====================================================
      -- トグルキーマップ
      -- Blame表示のオン/オフ切り替え
      -- =====================================================
      vim.keymap.set("n", "<leader>gb", "<cmd>GitBlameToggle<CR>", { desc = "Git Blame表示の有効/無効を切り替え" })
    end,
  },
}