-- =====================================================
-- UI/UX プラグイン設定
-- Neovimの見た目と使い勝手を劇的に改善
-- =====================================================

return {
  -- =====================================================
  -- TokyoNight：人気のカラーテーマ
  -- 目に優しく、コードが読みやすい配色
  -- =====================================================
  {
    "folke/tokyonight.nvim",
    priority = 1000,  -- 他のプラグインより先に読み込む（最重要）
    config = function()
      require("tokyonight").setup({
        style = "storm",           -- テーマスタイル（storm/night/moon/day）
        transparent = false,       -- 背景を透過させない（ターミナルの背景を見せない）
        terminal_colors = true,    -- ターミナルの色もテーマに合わせる
        styles = {
          comments = { italic = true },  -- コメントを斜体で表示（見分けやすく）
          keywords = { italic = true },  -- if/forなどのキーワードも斜体
        },
      })
      vim.cmd([[colorscheme tokyonight]])  -- テーマを実際に適用
    end,
  },

  -- =====================================================
  -- Lualine：ステータスライン（画面下部の情報バー）
  -- 現在のモード、ファイル名、Git状態などを表示
  -- =====================================================
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },  -- ファイルアイコン表示用
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",  -- カラーテーマと統一
          -- セクション間の区切り文字（powerlineスタイル）
          component_separators = { left = "", right = "" },  -- コンポーネント間
          section_separators = { left = "", right = "" },      -- セクション間
        },
        sections = {
          -- 各セクションの表示内容をカスタマイズ
          lualine_c = {  -- 中央セクション
            {
              "filename",
              path = 1,  -- 相対パスを表示（0=ファイル名のみ、1=相対、2=絶対）
            },
          },
          -- その他のセクション（a,b,d,e,f）はデフォルト設定を使用
        },
      })
    end,
  },

  -- =====================================================
  -- Oil.nvim：革新的なファイルエクスプローラー
  -- ファイルシステムをテキストエディタのように編集できる
  -- =====================================================
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },  -- ファイルアイコン
    config = function()
      require("oil").setup({
        -- 基本設定
        default_file_explorer = true,   -- netrwの代わりにOilを使用
        delete_to_trash = true,         -- 削除時はゴミ箱へ（完全削除しない）
        skip_confirm_for_simple_edits = true,  -- 単純な編集では確認を省略
        
        -- netrw完全置換設定
        constrain_cursor = "editable",  -- カーソルを編集可能な行に制限
        experimental_watch_for_changes = true,  -- ファイル変更を監視
        cleanup_delay_ms = 2000,        -- バッファクリーンアップの遅延

        -- 表示設定
        view_options = {
          show_hidden = true,           -- 隠しファイル（.で始まるファイル）を表示
          natural_order = true,         -- 自然な順序でソート（1,2,10の順、not 1,10,2）
        },

        -- フローティングウィンドウ設定
        float = {
          padding = 2,                  -- ウィンドウ内の余白
          max_width = 90,               -- 最大幅（画面の90%）
          max_height = 0,               -- 最大高さ（0=制限なし）
        },

        -- キーマップのカスタマイズ
        keymaps = {
          ["<C-c>"] = false,           -- Ctrl+Cのデフォルト動作を無効化
          ["q"] = "actions.close",     -- qで閉じる（Vimの慣習）
        },
      })

      -- グローバルキーマップ
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "親ディレクトリを開く（現在位置で）" })
      vim.keymap.set("n", "<leader>e", "<CMD>Oil --float<CR>", { desc = "ファイルエクスプローラー（フロート表示）" })

      -- ディレクトリを開いた時に自動でOilを起動する（改良版）
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("OilAutoOpen", { clear = true }),
        callback = function()
          -- 引数がある場合のみ処理
          if vim.fn.argc() == 1 then
            local arg = vim.fn.argv(0)
            if vim.fn.isdirectory(arg) == 1 then
              -- Dashboardよりも遅れて実行
              vim.defer_fn(function()
                -- 現在のバッファを削除してOilを開く
                vim.cmd("bdelete")
                require("oil").open(arg)
              end, 100) -- 100ms後に実行
            end
          end
        end,
      })

      -- バッファがディレクトリの場合にOilを開く
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("OilBufEnter", { clear = true }),
        callback = function(args)
          local bufname = vim.api.nvim_buf_get_name(args.buf)
          if bufname ~= "" and vim.fn.isdirectory(bufname) == 1 then
            -- Oilバッファでない場合のみ開く（無限ループ防止）
            if vim.bo[args.buf].filetype ~= "oil" then
              require("oil").open()
            end
          end
        end,
      })
    end,
  },

  -- =====================================================
  -- Which-key：キーマップのヘルプ表示
  -- どのキーで何ができるか表示してくれる初心者に優しい機能
  -- =====================================================
  {
    "folke/which-key.nvim",
    event = "VeryLazy",  -- 起動後に遅延読み込み
    init = function()
      vim.o.timeout = true      -- タイムアウトを有効化
      vim.o.timeoutlen = 500    -- 500ms待ってからヘルプを表示
    end,
    config = function()
      require("which-key").setup()

      -- リーダーキー（Space）のグループ名を登録
      -- これにより、Space押下後に何ができるか一覧表示される
      require("which-key").register({
        ["<leader>"] = {
          f = { name = "+検索" },        -- Space+f: ファイル検索関連
          g = { name = "+Git" },          -- Space+g: Git操作
          h = { name = "+ハンク" },       -- Space+h: Git変更箇所操作
          l = { name = "+LSP" },          -- Space+l: 言語サーバー機能
          s = { name = "+分割" },         -- Space+s: ウィンドウ分割
          t = { name = "+タブ/トグル" },  -- Space+t: タブ操作やトグル機能
          x = { name = "+トラブル" },     -- Space+x: エラー診断
          c = { name = "+コード" },       -- Space+c: コード操作
          d = { name = "+デバッグ" },     -- Space+d: デバッグ機能
          m = { name = "+フォーマット" }, -- Space+m: コード整形
          n = { name = "+通知" },         -- Space+n: 通知関連
          r = { name = "+リネーム/実行" }, -- Space+r: リネームやコード実行
          w = { name = "+保存" },         -- Space+w: ファイル保存
        },
      })
    end,
  },

  -- =====================================================
  -- nvim-notify：美しい通知システム
  -- エラーや情報を右上にポップアップ表示
  -- =====================================================
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        background_colour = "#000000",  -- 背景色（黒）
        render = "minimal",              -- ミニマルなデザイン（シンプル）
        stages = "fade",                 -- フェードイン/アウトアニメーション
      })
      vim.notify = require("notify")     -- Vimのデフォルト通知を置き換え
    end,
  },

  -- =====================================================
  -- Dashboard：スタート画面
  -- Neovim起動時に表示されるかっこいいメニュー
  -- =====================================================
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",  -- Vim起動時に表示
    cond = function()
      -- 引数がない場合、またはディレクトリ以外の場合のみDashboardを表示
      return vim.fn.argc() == 0 or (vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 0)
    end,
    config = function()
      require("dashboard").setup({
        theme = "doom",  -- Doomテーマ（Doom Emacsスタイル）
        config = {
          -- ヘッダー：NEOVIMのアスキーアート
          header = {
            [[                                                    ]],
            [[ ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗]],
            [[ ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║]],
            [[ ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║]],
            [[ ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║]],
            [[ ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║]],
            [[ ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
            [[                                                    ]],
          },
          -- センターメニュー：よく使う機能へのショートカット
          center = {
            { icon = " ", key = "f", desc = "ファイル検索", action = "FzfLua files" },
            { icon = " ", key = "n", desc = "新規ファイル", action = "ene | startinsert" },
            { icon = " ", key = "r", desc = "最近のファイル", action = "FzfLua oldfiles" },
            { icon = " ", key = "g", desc = "テキスト検索", action = "FzfLua live_grep" },
            { icon = " ", key = "c", desc = "設定", action = "e ~/.config/nvim/init.lua" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = "Lazy" },  -- プラグイン管理
            { icon = " ", key = "q", desc = "終了", action = "qa" },
          },
        },
      })
    end,
  },

  -- =====================================================
  -- indent-blankline：インデントガイド
  -- コードの階層構造を縦線で可視化
  -- =====================================================
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",  -- メインモジュール名
    event = { "BufReadPre", "BufNewFile" },  -- ファイルを開く時に起動
    opts = {
      indent = {
        char = "┊"  -- インデントを示す縦線の文字（細い点線）
      },
    },
  },

  -- =====================================================
  -- Snacks.nvim：UI改善詰め合わせ
  -- 様々な小さなUI改善を提供する最新プラグイン
  -- =====================================================
  {
    "folke/snacks.nvim",
    priority = 1000,     -- 優先的に読み込み
    lazy = false,        -- 遅延読み込みしない（すぐに必要）
    config = function()
      require("snacks").setup({
        bigfile = { enabled = true },      -- 巨大ファイル（数MB以上）を開く時の最適化
        notifier = { enabled = true },     -- 高度な通知システム
        quickfile = { enabled = true },    -- ファイルを高速に開く
        statuscolumn = { enabled = true }, -- 左端の列（行番号など）を改善
        words = { enabled = true },        -- カーソル下の単語を自動ハイライト
      })
    end,
  },
 }