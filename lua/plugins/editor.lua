-- =====================================================
-- エディタ拡張プラグイン設定
-- コーディングを効率化する基本的な機能を追加
-- =====================================================

return {
  -- =====================================================
  -- nvim-autopairs：括弧やクォートを自動で閉じる
  -- =====================================================
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",  -- 挿入モードに入った時に読み込み
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,  -- Treesitterと連携して言語に応じた動作
        ts_config = {
          lua = { "string", "source" },  -- Luaでは文字列とソース内で動作
          javascript = { "string", "template_string" },  -- JSでは文字列とテンプレート文字列内で動作
        },
        disable_filetype = { "TelescopePrompt", "spectre_panel" },  -- これらのファイルタイプでは無効
        fast_wrap = {
          map = "<M-e>",  -- Alt+eで高速ラップ（カーソル位置から括弧で囲む）
          chars = { "{", "[", "(", '"', "'" },  -- 対象文字
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),  -- パターン
          offset = 0,  -- オフセット
          end_key = "$",  -- 終了キー
          keys = "qwertyuiopzxcvbnmasdfghjkl",  -- 使用キー
          check_comma = true,  -- カンマをチェック
          highlight = "PmenuSel",  -- ハイライトグループ
          highlight_grey = "LineNr",  -- グレーハイライト
        },
      })

      -- nvim-cmpとの統合（自動補完と連携）
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())  -- 補完確定時に括弧を追加
    end,
  },

  -- =====================================================
  -- Comment.nvim：コメントアウトを簡単に
  -- =====================================================
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",  -- JSX/TSXなど複雑な言語対応
    },
    config = function()
      require("Comment").setup({
        padding = true,   -- コメント記号の後にスペースを入れる
        sticky = true,    -- カーソル位置を維持
        ignore = "^$",    -- 空行は無視

        -- トグル（切り替え）操作
        toggler = {
          line = "gcc",   -- gccで現在行のコメント切り替え
          block = "gbc",  -- gbcでブロックコメント切り替え
        },

        -- オペレータ（範囲指定）操作
        opleader = {
          line = "gc",    -- gc + 動作で行コメント
          block = "gb",   -- gb + 動作でブロックコメント
        },

        -- 追加機能
        extra = {
          above = "gcO",  -- 上に行コメントを追加
          below = "gco",  -- 下に行コメントを追加
          eol = "gcA",    -- 行末にコメントを追加
        },

        mappings = {
          basic = true,   -- 基本マッピング有効
          extra = true,   -- 追加マッピング有効
        },

        -- Treesitterと連携してJSX/TSXなどでも正しくコメント
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },

  -- =====================================================
  -- nvim-surround：テキストを括弧などで囲む/削除/変更
  -- =====================================================
  {
    "kylechui/nvim-surround",
    version = "*",  -- 安定版を使用
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          insert = "<C-g>s",         -- 挿入モード：Ctrl+g,sで囲む
          insert_line = "<C-g>S",    -- 挿入モード：行全体を囲む
          normal = "ys",             -- ノーマルモード：ys + 動作で囲む
          normal_cur = "yss",        -- ノーマルモード：現在行を囲む
          normal_line = "yS",        -- ノーマルモード：行を囲む（改行付き）
          normal_cur_line = "ySS",   -- ノーマルモード：現在行を囲む（改行付き）
          visual = "S",              -- ビジュアルモード：選択範囲を囲む
          visual_line = "gS",        -- ビジュアルライン：選択行を囲む
          delete = "ds",             -- 削除：ds + 文字で囲みを削除
          change = "cs",             -- 変更：cs + 古い文字 + 新しい文字で変更
        },
      })
    end,
  },

  -- =====================================================
  -- hop.nvim：画面内の任意の場所へ高速ジャンプ
  -- =====================================================
  {
    "smoka7/hop.nvim",
    version = "*",
    config = function()
      require("hop").setup({
        keys = "etovxqpdygfblzhckisuran",  -- ジャンプに使用する文字（ホームポジション優先）
      })

      -- fキーの拡張（1文字ジャンプ）
      vim.keymap.set("", "f", function()
        require("hop").hint_char1({
          direction = require("hop.hint").HintDirection.AFTER_CURSOR,  -- カーソル後方
          current_line_only = true  -- 現在行のみ
        })
      end, { remap = true, desc = "次の文字へジャンプ" })

      vim.keymap.set("", "F", function()
        require("hop").hint_char1({
          direction = require("hop.hint").HintDirection.BEFORE_CURSOR,  -- カーソル前方
          current_line_only = true
        })
      end, { remap = true, desc = "前の文字へジャンプ" })

      -- tキーの拡張（文字の前までジャンプ）
      vim.keymap.set("", "t", function()
        require("hop").hint_char1({
          direction = require("hop.hint").HintDirection.AFTER_CURSOR,
          current_line_only = true,
          hint_offset = -1  -- 文字の1つ前で止まる
        })
      end, { remap = true, desc = "次の文字の前へジャンプ" })

      vim.keymap.set("", "T", function()
        require("hop").hint_char1({
          direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
          current_line_only = true,
          hint_offset = 1  -- 文字の1つ後で止まる
        })
      end, { remap = true, desc = "前の文字の後へジャンプ" })

      -- 画面全体へのジャンプ
      vim.keymap.set("n", "<leader>hw", "<cmd>HopWord<CR>", { desc = "単語へジャンプ" })
      vim.keymap.set("n", "<leader>hl", "<cmd>HopLine<CR>", { desc = "行へジャンプ" })
    end,
  },

  -- =====================================================
  -- todo-comments.nvim：TODO/FIXME/NOTEなどをハイライト
  -- =====================================================
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("todo-comments").setup({
        signs = true,  -- 左端に記号を表示
        sign_priority = 8,  -- 記号の優先度

        -- キーワード設定（どんな単語をハイライトするか）
        keywords = {
          FIX = {
            icon = " ",  -- アイコン
            color = "error",  -- 色（エラー色）
            alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }  -- 同じ扱いにする単語
          },
          TODO = { icon = " ", color = "info" },
          HACK = { icon = " ", color = "warning" },
          WARN = {
            icon = " ",
            color = "warning",
            alt = { "WARNING", "XXX" }
          },
          PERF = {
            icon = " ",
            alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" }
          },
          NOTE = {
            icon = " ",
            color = "hint",
            alt = { "INFO" }
          },
          TEST = {
            icon = "⏲ ",
            color = "test",
            alt = { "TESTING", "PASSED", "FAILED" }
          },
        },
      })

      -- TODOコメント間のナビゲーション
      vim.keymap.set("n", "]t", function() require("todo-comments").jump_next() end, { desc = "次のTodoへ" })
      vim.keymap.set("n", "[t", function() require("todo-comments").jump_prev() end, { desc = "前のTodoへ" })
      vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Todo一覧を検索" })
    end,
  },

  -- =====================================================
  -- vim-illuminate：カーソル下の単語と同じ単語をハイライト
  -- =====================================================
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("illuminate").configure({
        -- ハイライトのプロバイダー（優先順位順）
        providers = {
          "lsp",        -- LSPを使用
          "treesitter", -- Treesitterを使用
          "regex",      -- 正規表現を使用
        },
        delay = 100,  -- ハイライトまでの遅延（ミリ秒）

        -- 除外するファイルタイプ
        filetypes_denylist = {
          "dirvish",
          "fugitive",
          "alpha",
          "NvimTree",
          "packer",
          "neogitstatus",
          "Trouble",
          "lir",
          "Outline",
          "spectre_panel",
          "toggleterm",
          "DressingSelect",
          "TelescopePrompt",
        },
        under_cursor = true,  -- カーソル下の単語もハイライト
        min_count_to_highlight = 1,  -- 最低1つマッチすればハイライト
      })
    end,
  },

  -- =====================================================
  -- undotree：アンドゥ履歴をツリー表示
  -- =====================================================
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",  -- コマンド実行時に読み込み
    config = function()
      vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<CR>", { desc = "アンドゥツリーを表示" })
    end,
  },
-- 
  -- =====================================================
  -- persistence.nvim：セッション管理（作業状態の保存/復元）
  -- =====================================================
  {
    "folke/persistence.nvim",
    event = "BufReadPre",  -- ファイル読み込み前に起動
    config = function()
      require("persistence").setup({
        dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),  -- セッション保存先
        options = { "buffers", "curdir", "tabpages", "winsize" },  -- 保存する内容
      })

      -- セッション操作のキーマップ
      vim.keymap.set("n", "<leader>qs", function() require("persistence").load() end, { desc = "セッションを復元" })
      vim.keymap.set("n", "<leader>ql", function() require("persistence").load({ last = true }) end, { desc = "最後のセッションを復元" })
      vim.keymap.set("n", "<leader>qd", function() require("persistence").stop() end, { desc = "セッション保存を停止" })
    end,
  },
}