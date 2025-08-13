-- =====================================================
-- 画面内高速移動・モーション検索
-- flash.nvimによる革新的なカーソル移動(f/F/t/Tの超強化版)
-- =====================================================

return {
  -- flash.nvim: 2-3キーで画面内のどこへでもジャンプ
  -- vim-easymotionやhop.nvimの進化版
  {
    "folke/flash.nvim",
    event = "VeryLazy",  -- 起動後に遅延読み込み

    -- キーマップ設定
    keys = {
      -- =====================================================
      -- 基本的なジャンプ機能
      -- =====================================================
      {
        "s",  -- sキーで発動(デフォルトのsコマンドを上書き)
        mode = { "n", "x", "o" },  -- Normal/Visual/Operator-pendingモード
        function() require("flash").jump() end,
        desc = "Flash ジャンプ(2文字入力→ラベル選択)"
      },

      {
        "S",  -- Shift+sでTreesitterベースのジャンプ
        mode = { "n", "x", "o" },
        function() require("flash").treesitter() end,
        desc = "Flash Treesitter(構文要素へジャンプ)"
      },

      {
        "r",  -- Operator-pendingモードでのリモート操作
        mode = "o",
        function() require("flash").remote() end,
        desc = "Remote Flash(離れた場所を操作)"
      },

      {
        "R",  -- Treesitterベースの検索
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc = "Treesitter Search(構文要素を検索)"
      },

      {
        "<c-s>",  -- Ctrl+sで検索モード切替
        mode = { "c" },  -- コマンドラインモード
        function() require("flash").toggle() end,
        desc = "Toggle Flash Search(検索モード切替)"
      },
    },

    opts = {
      -- =====================================================
      -- ラベル設定
      -- ジャンプ先に表示される文字の設定
      -- =====================================================
      labels = "asdfghjklqwertyuiopzxcvbnm",  -- 使用する文字(ホームポジション優先)

      -- =====================================================
      -- 検索設定
      -- =====================================================
      search = {
        multi_window = true,     -- 複数ウィンドウをまたいで検索
        forward = true,          -- 前方検索をデフォルトに
        wrap = true,             -- ファイル末尾で折り返し
        mode = "exact",          -- 検索モード(exact=完全一致, fuzzy=曖昧)
        incremental = false,     -- インクリメンタル検索(リアルタイム)

        -- 除外するウィンドウタイプ
        exclude = {
          "notify",              -- 通知ウィンドウ
          "cmp_menu",           -- 補完メニュー
          "noice",              -- noice.nvimのUI
          "flash_prompt",       -- flash自身のプロンプト
          function(win)
            -- フォーカス不可能なウィンドウを除外
            return not vim.api.nvim_win_get_config(win).focusable
          end,
        },
      },

      -- =====================================================
      -- ジャンプ設定
      -- =====================================================
      jump = {
        jumplist = true,         -- ジャンプリストに追加(Ctrl-o/Ctrl-iで戻る)
        pos = "start",           -- ジャンプ位置(start=先頭, end=末尾, range=範囲)
        history = false,         -- ジャンプ履歴を保存
        register = false,        -- レジスタに保存
        nohlsearch = false,      -- ジャンプ後に検索ハイライトをクリア
        autojump = false,        -- 候補が1つなら自動ジャンプ
      },

      -- =====================================================
      -- ラベル表示設定
      -- =====================================================
      label = {
        uppercase = true,        -- 大文字ラベルも使用(より多くの候補に対応)
        exclude = "",            -- ラベルから除外する文字
        current = true,          -- 現在位置にもラベル表示
        after = true,            -- マッチの後にラベル表示
        before = false,          -- マッチの前にラベル表示
        style = "overlay",       -- 表示スタイル(overlay=重ねる, inline=インライン, eol=行末)
        reuse = "lowercase",     -- ラベル再利用(all=全て, lowercase=小文字のみ, none=なし)
        distance = true,         -- 近い場所を優先してラベル割当
        min_pattern_length = 0,  -- 最小パターン長(0=制限なし)

        -- レインボーハイライト(距離による色分け)
        rainbow = {
          enabled = false,       -- レインボー表示
          shade = 5,             -- 色の段階数
        },
      },

      -- =====================================================
      -- ハイライト設定
      -- =====================================================
      highlight = {
        backdrop = true,         -- 背景を暗くして候補を見やすく
        matches = true,          -- マッチ箇所をハイライト
        priority = 5000,         -- ハイライトの優先度

        -- ハイライトグループ
        groups = {
          match = "FlashMatch",      -- マッチのハイライト
          current = "FlashCurrent",  -- 現在位置のハイライト
          backdrop = "FlashBackdrop", -- 背景のハイライト
          label = "FlashLabel",      -- ラベルのハイライト
        },
      },

      -- =====================================================
      -- プロンプト設定
      -- =====================================================
      prompt = {
        enabled = true,          -- プロンプト表示
        prefix = { { "⚡", "FlashPromptIcon" } },  -- プロンプトアイコン
        win_config = {
          relative = "editor",   -- エディタ相対位置
          width = 1,            -- 幅
          height = 1,           -- 高さ
          row = -1,             -- 行位置(下端)
          col = 0,              -- 列位置(左端)
          zindex = 1000,        -- z-index(重なり順序)
        },
      },

      -- =====================================================
      -- モード別設定
      -- =====================================================
      modes = {
        -- 検索モード(/, ?)の拡張
        search = {
          enabled = true,        -- 有効化
          highlight = { backdrop = false },  -- 背景ハイライトなし
          jump = {
            history = true,      -- ジャンプ履歴に追加
            register = true,     -- レジスタに保存
            nohlsearch = true    -- ジャンプ後にハイライトクリア
          },
          search = {
            forward = true,      -- 前方検索
            mode = "fuzzy",      -- ファジー検索
            incremental = true,  -- インクリメンタル検索
          },
        },

        -- 文字モード(f/F/t/Tの拡張)
        char = {
          enabled = true,        -- 有効化
          config = function(opts)
            -- yank時は自動的に非表示
            opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")
            -- カウントが0の時のみラベル表示
            opts.jump_labels = opts.jump_labels and vim.v.count == 0
          end,
          autohide = false,      -- 自動非表示
          jump_labels = false,   -- ジャンプラベル表示
          multi_line = true,     -- 複数行対応
          label = { exclude = "hjkliardc" },  -- 除外文字(移動キーと被らないように)
          keys = { "f", "F", "t", "T", ";", "," },  -- 対応キー

          -- 文字アクション(;と,で次/前へ)
          char_actions = function(motion)
            return {
              [";"] = "next",     -- 次のマッチへ
              [","] = "prev",     -- 前のマッチへ
              [motion:lower()] = "next",  -- 小文字で次へ
              [motion:upper()] = "prev",  -- 大文字で前へ
            }
          end,
          search = { wrap = false },  -- 折り返しなし
          highlight = { backdrop = true },  -- 背景ハイライト
          jump = { register = false },  -- レジスタに保存しない
        },

        -- Treesitterモード(構文要素へのジャンプ)
        treesitter = {
          labels = "abcdefghijklmnopqrstuvwxyz",
          jump = { pos = "range" },  -- 範囲選択
          search = { incremental = false },
          label = {
            before = true,       -- 前にラベル表示
            after = true,        -- 後にラベル表示
            style = "inline"     -- インライン表示
          },
          highlight = {
            backdrop = false,    -- 背景ハイライトなし
            matches = false,     -- マッチハイライトなし
          },
        },

        -- Treesitter検索モード
        treesitter_search = {
          jump = { pos = "range" },
          search = {
            multi_window = true,  -- 複数ウィンドウ対応
            wrap = true,          -- 折り返し
            incremental = false   -- インクリメンタルなし
          },
          remote_op = { restore = true },  -- 操作後に復元
          label = {
            before = true,
            after = true,
            style = "inline"
          },
        },

        -- リモートモード(離れた場所の操作)
        remote = {
          remote_op = {
            restore = true,      -- 操作後にカーソル位置を復元
            motion = true        -- モーションとして動作
          },
        },
      },
    },
  },
}