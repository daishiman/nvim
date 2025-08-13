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
  -- nvim-tree：VSCodeライクなファイルツリー
  -- 左サイドバーにディレクトリツリーを表示し、
  -- 右側で同時にファイルを編集できる
  -- =====================================================
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,  -- 遅延読み込みを無効にして即座に読み込み
    priority = 1000,  -- 高い優先度で読み込み
    dependencies = { "nvim-tree/nvim-web-devicons" },  -- ファイルアイコン
    config = function()
      -- netrwを無効化（nvim-tree使用のため）
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require("nvim-tree").setup({
        -- =====================================================
        -- 基本設定
        -- =====================================================
        sort_by = "name",                    -- ファイルの並び順
        auto_reload_on_write = true,         -- ファイル保存時に自動リロード
        disable_netrw = true,               -- netrwを無効化
        hijack_netrw = true,                -- netrwを乗っ取り
        hijack_cursor = false,              -- カーソルをツリーに移動しない

        -- =====================================================
        -- ツリー表示設定
        -- =====================================================
        view = {
          adaptive_size = false,            -- ウィンドウサイズ自動調整無効
          centralize_selection = false,     -- 選択項目を中央に移動しない
          width = 35,                       -- ツリーの幅（文字数）
          hide_root_folder = false,         -- ルートフォルダを表示
          side = "left",                    -- 左側に表示
          preserve_window_proportions = false,
          number = false,                   -- 行番号非表示
          relativenumber = false,           -- 相対行番号非表示
          signcolumn = "yes",               -- サインカラム表示
          mappings = {
            custom_only = false,
            list = {
              { key = "u", action = "dir_up" },  -- u で親ディレクトリ
              { key = "v", action = "vsplit" },   -- v で垂直分割で開く
              { key = "s", action = "split" },    -- s で水平分割で開く
            },
          },
        },

        -- =====================================================
        -- レンダラー（見た目）設定
        -- =====================================================
        renderer = {
          add_trailing = false,             -- フォルダ名に/を追加しない
          group_empty = false,              -- 空フォルダをグループ化しない
          highlight_git = false,            -- Gitファイルをハイライトしない
          full_name = false,                -- フルパス表示しない
          highlight_opened_files = "none",  -- 開いているファイルをハイライトしない
          root_folder_modifier = ":~",      -- ルートフォルダ表示形式
          indent_width = 2,                 -- インデント幅
          indent_markers = {
            enable = true,                  -- インデント線を表示
            inline_arrows = true,           -- インライン矢印
            icons = {
              corner = "└",
              edge = "│",
              item = "│",
              bottom = "─",
              none = " ",
            },
          },
          icons = {
            webdev_colors = true,           -- Web開発用カラーアイコン
            git_placement = "before",       -- Git状態アイコンの位置
            padding = " ",                  -- アイコンの間隔
            symlink_arrow = " ➛ ",         -- シンボリックリンクの矢印
            show = {
              file = true,                  -- ファイルアイコン表示
              folder = true,                -- フォルダアイコン表示
              folder_arrow = true,          -- フォルダ矢印表示
              git = true,                   -- Git状態アイコン表示
            },
            glyphs = {
              default = "",                -- デフォルトファイルアイコン
              symlink = "",                -- シンボリックリンクアイコン
              bookmark = "",               -- ブックマークアイコン
              folder = {
                arrow_closed = "",         -- 閉じたフォルダ矢印
                arrow_open = "",           -- 開いたフォルダ矢印
                default = "",              -- デフォルトフォルダ
                open = "",                 -- 開いたフォルダ
                empty = "",                -- 空フォルダ
                empty_open = "",           -- 開いた空フォルダ
                symlink = "",              -- シンボリックリンクフォルダ
                symlink_open = "",         -- 開いたシンボリックリンクフォルダ
              },
              git = {
                unstaged = "✗",             -- 未ステージング
                staged = "✓",               -- ステージング済み
                unmerged = "",              -- マージ未完了
                renamed = "➜",              -- リネーム
                untracked = "★",            -- 未追跡
                deleted = "",               -- 削除
                ignored = "◌",              -- 無視
              },
            },
          },
          special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
        },

        -- =====================================================
        -- フィルター設定
        -- =====================================================
        filters = {
          dotfiles = false,                 -- ドットファイルを表示
          custom = {},                      -- カスタムフィルター
          exclude = {},                     -- 除外パターン
        },

        -- =====================================================
        -- Git統合
        -- =====================================================
        git = {
          enable = true,                    -- Git統合有効
          ignore = true,                    -- .gitignoreを考慮
          show_on_dirs = true,              -- ディレクトリにもGit状態表示
          timeout = 400,                    -- タイムアウト（ミリ秒）
        },

        -- =====================================================
        -- アクション設定
        -- =====================================================
        actions = {
          use_system_clipboard = true,      -- システムクリップボード使用
          change_dir = {
            enable = true,                  -- ディレクトリ変更を有効
            global = false,                 -- グローバル変更は無効
            restrict_above_cwd = false,     -- 作業ディレクトリ上の制限なし
          },
          expand_all = {
            max_folder_discovery = 300,     -- フォルダ発見の最大数
            exclude = { ".git", "target", "build" },
          },
          file_popup = {
            open_win_config = {
              col = 1,
              row = 1,
              relative = "cursor",
              border = "shadow",
              style = "minimal",
            },
          },
          open_file = {
            quit_on_open = false,           -- ファイルを開いてもツリーを閉じない
            resize_window = true,           -- ウィンドウサイズ調整
            window_picker = {
              enable = true,                -- ウィンドウ選択を有効
              picker = "default",           -- デフォルトピッカー使用
              chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
              exclude = {
                filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
                buftype = { "nofile", "terminal", "help" },
              },
            },
          },
          remove_file = {
            close_window = true,            -- ファイル削除時にウィンドウを閉じる
          },
        },

        -- =====================================================
        -- 起動時設定
        -- =====================================================
        tab = {
          sync = {
            open = true,                    -- タブ同期でツリーを開く
            close = true,                   -- タブ同期でツリーを閉じる
          },
        },

        notify = {
          threshold = vim.log.levels.INFO,  -- 通知レベル
        },

        log = {
          enable = false,                   -- ログを無効化
        },

        -- =====================================================
        -- UI設定
        -- =====================================================
        ui = {
          confirm = {
            remove = true,                  -- 削除時に確認
            trash = true,                   -- ゴミ箱移動時に確認
          },
        },

        -- =====================================================
        -- システム設定
        -- =====================================================
        system_open = {
          cmd = "open",                     -- macOSのopenコマンド使用
          args = {},
        },

        -- =====================================================
        -- 診断設定
        -- =====================================================
        diagnostics = {
          enable = false,                   -- 診断表示を無効
          show_on_dirs = false,             -- ディレクトリに診断表示しない
          debounce_delay = 50,              -- デバウンス遅延
          severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
          },
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          },
        },

        -- =====================================================
        -- 更新設定
        -- =====================================================
        update_focused_file = {
          enable = true,                    -- フォーカスファイル更新を有効
          update_root = true,               -- ルート更新
          ignore_list = {},                 -- 無視リスト
        },

        -- =====================================================
        -- ファイル表示設定
        -- =====================================================
        hijack_directories = {
          enable = true,                    -- ディレクトリ乗っ取り有効
          auto_open = true,                 -- 自動オープン
        },

        -- =====================================================
        -- 削除対象バッファ設定
        -- =====================================================
        remove_keymaps = false,             -- デフォルトキーマップを削除しない
        sync_root_with_cwd = true,          -- 作業ディレクトリと同期
        reload_on_bufenter = true,          -- バッファ入力時にリロード
        respect_buf_cwd = false,            -- バッファのcwdを無視
      })

      -- =====================================================
      -- キーマップ設定
      -- =====================================================
      -- ツリーのトグル（表示/非表示切り替え）
      vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "ファイルツリーを開く/閉じる" })
      
      -- ツリーにフォーカス
      vim.keymap.set("n", "<leader>ef", "<cmd>NvimTreeFocus<CR>", { desc = "ファイルツリーにフォーカス" })
      
      -- 現在のファイルを見つける
      vim.keymap.set("n", "<leader>er", "<cmd>NvimTreeFindFile<CR>", { desc = "現在のファイルをツリーで表示" })
      
      -- ツリーを折りたたみ
      vim.keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "ツリーを折りたたみ" })

      -- ディレクトリ自動表示（グローバル変数ベース）
      local function setup_auto_open()
        -- 常にツリーを表示
        require("nvim-tree.api").tree.open()

        -- ディレクトリが指定されていた場合の処理
        if vim.g.nvim_tree_should_open and vim.g.nvim_tree_target_dir then
          -- ルートディレクトリを設定
          if vim.g.nvim_tree_target_dir ~= vim.fn.getcwd() then
            require("nvim-tree.api").tree.change_root(vim.g.nvim_tree_target_dir)
          end

          -- ディレクトリバッファを削除
          vim.schedule(function()
            local bufs = vim.api.nvim_list_bufs()
            for _, buf in ipairs(bufs) do
              local bufname = vim.api.nvim_buf_get_name(buf)
              if vim.fn.isdirectory(bufname) == 1 then
                vim.cmd("silent! bdelete " .. buf)
              end
            end
          end)

          -- エディタエリアにフォーカスを移動
          vim.schedule(function()
            local wins = vim.api.nvim_list_wins()
            for _, win in ipairs(wins) do
              local buf = vim.api.nvim_win_get_buf(win)
              if vim.bo[buf].filetype ~= "NvimTree" then
                vim.api.nvim_set_current_win(win)
                break
              end
            end
          end)
        end

        -- ファイルが指定された場合の処理
        if vim.fn.argc() > 0 then
          local arg = vim.fn.argv(0)
          if vim.fn.filereadable(arg) == 1 then
            -- ファイルの親ディレクトリをルートに設定
            local file_dir = vim.fn.fnamemodify(arg, ":p:h")
            require("nvim-tree.api").tree.change_root(file_dir)
            
            -- ファイルを開く
            vim.cmd("edit " .. arg)
            
            -- ツリーでファイルを選択状態にする
            vim.schedule(function()
              require("nvim-tree.api").tree.find_file(vim.fn.fnamemodify(arg, ":p"))
            end)
          end
        end
      end

      -- 設定完了後に即座に実行
      vim.schedule(setup_auto_open)

      -- VimEnterイベントでも実行（バックアップ）
      vim.api.nvim_create_autocmd("VimEnter", {
        group = vim.api.nvim_create_augroup("NvimTreeAutoOpen", { clear = true }),
        callback = function()
          if not require("nvim-tree.api").tree.is_visible() then
            vim.defer_fn(setup_auto_open, 50)
          end
        end,
      })

      -- バッファが閉じられてもツリーを維持 & ディレクトリバッファの処理
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("NvimTreeKeepOpen", { clear = true }),
        callback = function(args)
          local bufname = vim.api.nvim_buf_get_name(args.buf)
          
          -- ディレクトリバッファ（特に "." ）を自動的に削除
          if bufname ~= "" and vim.fn.isdirectory(bufname) == 1 then
            -- ツリーが表示されていない場合は表示
            if not require("nvim-tree.api").tree.is_visible() then
              require("nvim-tree.api").tree.open()
            end
            
            -- ディレクトリバッファを削除
            vim.defer_fn(function()
              if vim.api.nvim_buf_is_valid(args.buf) then
                vim.cmd("bdelete " .. args.buf)
              end
            end, 50)
            return
          end
          
          -- 通常のバッファが残っていない場合はツリーを開く
          local bufs = vim.api.nvim_list_bufs()
          local normal_bufs = 0
          for _, buf in ipairs(bufs) do
            if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted and vim.bo[buf].filetype ~= "NvimTree" then
              local buf_name = vim.api.nvim_buf_get_name(buf)
              -- ディレクトリバッファは除外
              if buf_name == "" or vim.fn.isdirectory(buf_name) == 0 then
                normal_bufs = normal_bufs + 1
              end
            end
          end
          
          -- 通常のバッファがない場合はツリーを開く
          if normal_bufs == 0 and not require("nvim-tree.api").tree.is_visible() then
            require("nvim-tree.api").tree.open()
          end
        end,
      })
    end,
  },

  -- =====================================================
  -- Oil.nvim：高度なファイル編集用（フローティング専用）
  -- フローティングウィンドウでファイルシステム編集
  -- =====================================================
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },  -- ファイルアイコン
    config = function()
      require("oil").setup({
        -- 基本設定（フローティングのみ使用）
        default_file_explorer = false,     -- nvim-treeをメインに使用
        delete_to_trash = true,             -- 削除時はゴミ箱へ
        skip_confirm_for_simple_edits = true,
        
        -- 表示設定
        view_options = {
          show_hidden = true,               -- 隠しファイル表示
          natural_order = true,             -- 自然な順序でソート
        },

        -- フローティングウィンドウ設定
        float = {
          padding = 2,                      -- ウィンドウ内の余白
          max_width = 90,                   -- 最大幅（画面の90%）
          max_height = 0,                   -- 最大高さ（0=制限なし）
        },

        -- キーマップのカスタマイズ
        keymaps = {
          ["<C-c>"] = false,               -- Ctrl+Cの無効化
          ["q"] = "actions.close",         -- qで閉じる
        },
      })

      -- フローティングOilのキーマップ
      vim.keymap.set("n", "<leader>o", "<CMD>Oil --float<CR>", { desc = "Oil（フローティング）" })
      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Oil（現在位置で）" })
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
          e = { name = "+エクスプローラー" }, -- Space+e: ファイルツリー関連
          f = { name = "+検索" },        -- Space+f: ファイル検索関連
          g = { name = "+Git" },          -- Space+g: Git操作
          h = { name = "+ハンク" },       -- Space+h: Git変更箇所操作
          l = { name = "+LSP" },          -- Space+l: 言語サーバー機能
          o = { name = "+Oil" },          -- Space+o: Oil関連
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
      -- nvim-treeを常に表示するため、Dashboardは無効化
      return false
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
            { icon = " ", key = "e", desc = "ファイルツリー", action = "NvimTreeToggle" },
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