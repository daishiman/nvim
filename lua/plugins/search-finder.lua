-- =====================================================
-- 高速ファイル・テキスト検索
-- fzf-luaを使用した超高速な検索機能(Telescopeより3-5倍高速)
-- =====================================================

return {
  -- fzf-lua: 最速のファジーファインダー
  -- ネイティブfzfをLuaでラップし、Neovimに最適化
  {
    "ibhagwan/fzf-lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons"  -- ファイルアイコン表示用
    },
    event = "VeryLazy",  -- 起動後に遅延読み込み(起動速度を優先)

    -- キーマップ設定(検索系の主要キーバインド)
    keys = {
      -- =====================================================
      -- ファイル検索
      -- =====================================================
      { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "ファイル検索" },
      { "<leader>fo", "<cmd>FzfLua oldfiles<cr>", desc = "最近開いたファイル" },
      { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "バッファ一覧" },

      -- =====================================================
      -- テキスト検索(grep)
      -- =====================================================
      { "<leader>fg", "<cmd>FzfLua live_grep<cr>", desc = "Live grep(リアルタイム検索)" },
      { "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "カーソル下の単語を検索" },
      { "<leader>fW", "<cmd>FzfLua grep_cWORD<cr>", desc = "カーソル下のWORDを検索" },
      { "<leader>fv", "<cmd>FzfLua grep_visual<cr>", mode = "v", desc = "選択テキストを検索" },
      { "<leader>fl", "<cmd>FzfLua blines<cr>", desc = "現在バッファ内検索" },
      { "<leader>fL", "<cmd>FzfLua lines<cr>", desc = "全バッファ内検索" },

      -- =====================================================
      -- Git検索
      -- =====================================================
      { "<leader>gf", "<cmd>FzfLua git_files<cr>", desc = "Gitファイル検索" },
      { "<leader>gs", "<cmd>FzfLua git_status<cr>", desc = "Git status(変更ファイル)" },
      { "<leader>gc", "<cmd>FzfLua git_commits<cr>", desc = "Gitコミット履歴" },
      { "<leader>gb", "<cmd>FzfLua git_branches<cr>", desc = "Gitブランチ一覧" },

      -- =====================================================
      -- LSP検索(コードナビゲーション)
      -- =====================================================
      { "gd", "<cmd>FzfLua lsp_definitions<cr>", desc = "定義へジャンプ" },
      { "gr", "<cmd>FzfLua lsp_references<cr>", desc = "参照箇所を検索" },
      { "gi", "<cmd>FzfLua lsp_implementations<cr>", desc = "実装へジャンプ" },
      { "gt", "<cmd>FzfLua lsp_typedefs<cr>", desc = "型定義へジャンプ" },
      { "<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "ドキュメントシンボル" },
      { "<leader>fS", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "ワークスペースシンボル" },
      { "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", desc = "ドキュメント診断" },
      { "<leader>fD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "ワークスペース診断" },
      { "<leader>ca", "<cmd>FzfLua lsp_code_actions<cr>", desc = "コードアクション" },

      -- =====================================================
      -- その他の便利機能
      -- =====================================================
      { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "キーマップ一覧" },
      { "<leader>fh", "<cmd>FzfLua command_history<cr>", desc = "コマンド履歴" },
      { "<leader>f:", "<cmd>FzfLua search_history<cr>", desc = "検索履歴" },
      { "<leader>fm", "<cmd>FzfLua marks<cr>", desc = "マーク一覧" },
      { "<leader>fj", "<cmd>FzfLua jumps<cr>", desc = "ジャンプリスト" },
      { "<leader>fr", "<cmd>FzfLua registers<cr>", desc = "レジスタ一覧" },
      { "<leader>ft", "<cmd>FzfLua help_tags<cr>", desc = "ヘルプタグ検索" },
      { "<leader>fC", "<cmd>FzfLua colorschemes<cr>", desc = "カラースキーム選択" },
    },

    config = function()
      local fzf = require("fzf-lua")

      fzf.setup({
        -- =====================================================
        -- ウィンドウ設定
        -- 検索ウィンドウの見た目とレイアウト
        -- =====================================================
        winopts = {
          height = 0.85,            -- ウィンドウ高さ(画面の85%)
          width = 0.80,             -- ウィンドウ幅(画面の80%)
          row = 0.35,               -- 表示位置・縦(上から35%)
          col = 0.50,               -- 表示位置・横(左から50%=中央)
          border = "rounded",       -- 枠線スタイル(rounded/single/double/shadow)
          fullscreen = false,       -- フルスクリーンモード

          -- プレビューウィンドウ設定
          preview = {
            border = "border",      -- プレビューの枠線
            wrap = "nowrap",        -- 行折り返し(nowrap/wrap)
            hidden = "nohidden",    -- デフォルトで表示(hidden/nohidden)
            vertical = "down:45%",  -- 垂直分割時のサイズ
            horizontal = "right:60%", -- 水平分割時のサイズ
            layout = "flex",        -- レイアウト(flex/vertical/horizontal)
            flip_columns = 120,     -- この幅以下で垂直レイアウトに切替
            title = true,           -- タイトル表示
            scrollbar = true,       -- スクロールバー表示
            delay = 100,            -- プレビュー表示の遅延(ミリ秒)
          },
        },

        -- =====================================================
        -- キーバインド設定
        -- 検索ウィンドウ内での操作
        -- =====================================================
        keymap = {
          -- ビルトインキーマップ(fzf-lua独自の機能)
          builtin = {
            ["<F1>"] = "toggle-help",         -- ヘルプ表示切替
            ["<F2>"] = "toggle-fullscreen",   -- フルスクリーン切替
            ["<F3>"] = "toggle-preview-wrap", -- プレビューの折り返し切替
            ["<F4>"] = "toggle-preview",      -- プレビュー表示切替
            ["<C-d>"] = "preview-page-down",  -- プレビューを下にスクロール
            ["<C-u>"] = "preview-page-up",    -- プレビューを上にスクロール
          },

          -- fzfコマンドのキーマップ
          fzf = {
            ["ctrl-z"] = "abort",              -- 検索を中止
            ["ctrl-a"] = "beginning-of-line",  -- 行頭へ移動
            ["ctrl-e"] = "end-of-line",        -- 行末へ移動
            ["alt-a"] = "toggle-all",          -- 全選択/解除切替
            ["ctrl-q"] = "select-all+accept",  -- 全選択して確定(Quickfixへ)
          },
        },

        -- =====================================================
        -- プレビューハイライト設定（treesitter無効化）
        -- =====================================================
        previewers = {
          builtin = {
            syntax = false,           -- シンタックスハイライト無効化
            syntax_limit_l = 0,       -- ハイライト制限無し
            syntax_limit_b = 0,       -- ハイライト制限無し  
            treesitter = {
              enable = false,         -- treesitter完全無効化
            },
          },
        },

        -- =====================================================
        -- ファイル検索設定
        -- =====================================================
        files = {
          prompt = "Files❯ ",          -- プロンプト表示
          multiprocess = true,         -- マルチプロセス有効(高速化)
          git_icons = true,            -- Gitステータスアイコン表示
          file_icons = true,           -- ファイルタイプアイコン表示
          color_icons = true,          -- カラーアイコン

          -- ripgrepの検索オプション(高速検索用)
          rg_opts = "--color=never --files --hidden --follow -g '!.git'",
          -- fdの検索オプション(代替検索ツール)
          fd_opts = "--color=never --type f --hidden --follow --exclude .git",
        },

        -- =====================================================
        -- grep検索設定
        -- =====================================================
        grep = {
          prompt = "Rg❯ ",                -- プロンプト表示
          input_prompt = "Grep For❯ ",     -- 入力プロンプト
          multiprocess = true,            -- マルチプロセス有効(高速化)
          git_icons = true,               -- Gitアイコン表示
          file_icons = true,              -- ファイルアイコン表示

          -- ripgrepのオプション(高速・高機能な検索)
          rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",

          -- glob設定(ファイルパターンでフィルタ)
          rg_glob = true,                 -- glob機能を有効化
          glob_flag = "--iglob",          -- globフラグ(大文字小文字無視)
          glob_separator = "%s%-%-",      -- glob区切り文字
        },

        -- =====================================================
        -- Git検索設定
        -- =====================================================
        git = {
          files = {
            prompt = "GitFiles❯ ",
            cmd = "git ls-files --exclude-standard",
            multiprocess = true,          -- マルチプロセスで高速化
            git_icons = true,             -- Gitアイコン表示
            file_icons = true,            -- ファイルアイコン表示
          },

          status = {
            prompt = "GitStatus❯ ",
            file_icons = true,
            git_icons = true,
            previewer = "git_diff",       -- Git差分をプレビュー表示
          },

          commits = {
            prompt = "Commits❯ ",
            cmd = "git log --pretty=oneline --abbrev-commit --color",
            preview = "git show --pretty='%Cred%H%n%Cblue%an <%ae>%n%C(yellow)%cD%n%Cgreen%s' --color {1}",
          },
        },

        -- =====================================================
        -- LSP検索設定
        -- =====================================================
        lsp = {
          prompt_postfix = "❯ ",         -- プロンプト後置文字
          cwd_only = false,               -- 現在のディレクトリのみ検索
          async_or_timeout = 5000,        -- タイムアウト時間(ミリ秒)
          file_icons = true,              -- ファイルアイコン表示
          git_icons = false,              -- Gitアイコンは非表示

          -- シンボルアイコン設定
          symbols = {
            prompt = "Symbols❯ ",
            symbol_style = 1,             -- アイコンスタイル

            -- 各シンボルタイプのアイコン定義
            symbol_icons = {
              File = "󰈙",
              Module = "",
              Namespace = "󰌗",
              Package = "",
              Class = "󰌗",
              Method = "󰆧",
              Property = "",
              Field = "",
              Constructor = "",
              Enum = "󰕘",
              Interface = "󰕘",
              Function = "󰊕",
              Variable = "󰆧",
              Constant = "󰏿",
              String = "󰀬",
              Number = "󰎠",
              Boolean = "◩",
              Array = "󰅪",
              Object = "󰅩",
              Key = "󰌋",
              Null = "󰟢",
              EnumMember = "",
              Struct = "󰌗",
              Event = "",
              Operator = "󰆕",
              TypeParameter = "󰊄",
            },
          },
        },
      })
    end,
  },
}