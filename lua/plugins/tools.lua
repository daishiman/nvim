-- =====================================================
-- 開発ツール設定
-- ターミナル、API開発、プレビュー、実行環境などの便利ツール
-- =====================================================

return {
  -- =====================================================
  -- ToggleTerm：高機能ターミナル統合
  -- Neovim内で複数のターミナルを管理
  -- =====================================================
  {
    "akinsho/toggleterm.nvim",
    version = "*",  -- 安定版を使用
    config = function()
      require("toggleterm").setup({
        -- ターミナルウィンドウのサイズ設定
        size = function(term)
          if term.direction == "horizontal" then
            return 15  -- 水平分割時は15行
          elseif term.direction == "vertical" then
            return vim.o.columns * 0.4  -- 垂直分割時は画面幅の40%
          end
        end,

        -- 基本設定
        open_mapping = [[<c-\>]],  -- Ctrl+\でターミナルの表示/非表示を切り替え
        hide_numbers = true,        -- 行番号を非表示
        shade_filetypes = {},       -- 特定のファイルタイプでシェーディング
        shade_terminals = true,     -- ターミナル背景を暗くする
        shading_factor = 2,         -- 暗さの度合い（1-3、大きいほど暗い）
        start_in_insert = true,     -- ターミナルを開いたら挿入モードで開始
        insert_mappings = true,     -- 挿入モードでマッピング有効
        terminal_mappings = true,   -- ターミナルモードでマッピング有効
        persist_size = true,        -- ウィンドウサイズを記憶
        persist_mode = true,        -- モード（挿入/ノーマル）を記憶
        direction = "float",        -- デフォルトの表示方法（float/horizontal/vertical/tab）
        close_on_exit = true,       -- プロセス終了時に自動で閉じる
        shell = vim.o.shell,        -- 使用するシェル（システムデフォルト）

        -- フローティングウィンドウの設定
        float_opts = {
          border = "curved",        -- 枠線スタイル（角丸）
          winblend = 0,            -- 透明度（0=不透明、100=透明）
          highlights = {
            border = "Normal",      -- 枠線のハイライトグループ
            background = "Normal",  -- 背景のハイライトグループ
          },
        },
      })

      -- =====================================================
      -- ターミナル内でのキーマップ設定
      -- ターミナルモードでも通常のVim操作を可能にする
      -- =====================================================
      function _G.set_terminal_keymaps()
        local opts = { buffer = 0 }  -- 現在のバッファのみに適用

        -- ターミナルモードから抜ける
        vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)  -- Escでノーマルモード
        vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)     -- jkでもノーマルモード

        -- ウィンドウ間の移動（ターミナル内からでも移動可能）
        vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)  -- 左のウィンドウへ
        vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)  -- 下のウィンドウへ
        vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)  -- 上のウィンドウへ
        vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)  -- 右のウィンドウへ
      end

      -- ターミナルを開いた時に自動でキーマップを設定
      vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

      -- =====================================================
      -- 特定用途のターミナル設定
      -- よく使うツール専用のターミナルを作成
      -- =====================================================
      local Terminal = require("toggleterm.terminal").Terminal

      -- LazyGit（Git GUI）用ターミナル
      local lazygit = Terminal:new({
        cmd = "lazygit",           -- 実行コマンド
        hidden = true,              -- 非表示時も維持
        direction = "float",        -- フローティングで表示
        float_opts = {
          border = "double",        -- 二重線の枠
        },
      })

      -- LazyGitトグル関数（グローバル関数として定義）
      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end

      vim.keymap.set("n", "<leader>tg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", { desc = "LazyGit（Git GUI）を開く" })

      -- Python REPL（対話型実行環境）
      local python = Terminal:new({
        cmd = "python3",            -- Python3を起動
        hidden = true,
        direction = "horizontal",   -- 水平分割で表示
      })

      function _PYTHON_TOGGLE()
        python:toggle()
      end

      vim.keymap.set("n", "<leader>tp", "<cmd>lua _PYTHON_TOGGLE()<CR>", { desc = "Python対話環境を開く" })

      -- Node.js REPL
      local node = Terminal:new({
        cmd = "node",               -- Node.jsを起動
        hidden = true,
        direction = "horizontal",   -- 水平分割で表示
      })

      function _NODE_TOGGLE()
        node:toggle()
      end

      vim.keymap.set("n", "<leader>tn", "<cmd>lua _NODE_TOGGLE()<CR>", { desc = "Node.js対話環境を開く" })
    end,
  },

  -- =====================================================
  -- rest.nvim：REST APIクライアント
  -- HTTPリクエストをNeovim内から送信（Postmanの代替）
  -- =====================================================
  {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = "http",  -- .httpファイルで自動起動
    config = function()
      require("rest-nvim").setup({
        -- 結果表示設定
        result_split_horizontal = false,  -- 垂直分割で結果表示
        result_split_in_place = false,    -- 新しいウィンドウで表示
        skip_ssl_verification = false,    -- SSL証明書を検証する
        encode_url = true,                -- URLを自動エンコード

        -- ハイライト設定
        highlight = {
          enabled = true,                 -- シンタックスハイライト有効
          timeout = 150,                  -- タイムアウト時間（ミリ秒）
        },

        -- 結果表示の詳細設定
        result = {
          show_url = true,                -- リクエストURLを表示
          show_http_info = true,          -- HTTPメソッドとステータスを表示
          show_headers = true,            -- レスポンスヘッダーを表示
          formatters = {
            json = "jq",                  -- JSONをjqでフォーマット
            html = function(body)         -- HTMLをtidyでフォーマット
              return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
            end,
          },
        },

        jump_to_request = false,          -- リクエスト実行後にジャンプしない
        env_file = ".env",                -- 環境変数ファイル
        custom_dynamic_variables = {},    -- カスタム動的変数
        yank_dry_run = true,             -- ドライラン結果をヤンク可能
      })

      -- キーマップ（.httpファイル内で使用）
      vim.keymap.set("n", "<leader>rr", "<Plug>RestNvim", { desc = "APIリクエストを実行" })
      vim.keymap.set("n", "<leader>rp", "<Plug>RestNvimPreview", { desc = "curlコマンドをプレビュー" })
      vim.keymap.set("n", "<leader>rl", "<Plug>RestNvimLast", { desc = "最後のリクエストを再実行" })
    end,
  },

  -- =====================================================
  -- markdown-preview.nvim：Markdownプレビュー
  -- リアルタイムでMarkdownをブラウザプレビュー
  -- =====================================================
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    -- 代替案：npmを使う場合
    -- build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    config = function()
      -- Markdown Previewの設定
      vim.g.mkdp_auto_start = 0
      vim.g.mkdp_auto_close = 1
      vim.g.mkdp_refresh_slow = 0
      vim.g.mkdp_command_for_global = 0
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_open_ip = ''
      vim.g.mkdp_browser = ''
      vim.g.mkdp_echo_preview_url = 0
      vim.g.mkdp_browserfunc = ''
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = 'middle',
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false
      }
      vim.g.mkdp_markdown_css = ''
      vim.g.mkdp_highlight_css = ''
      vim.g.mkdp_port = ''
      vim.g.mkdp_page_title = '「${name}」'
    end,
  },

  -- =====================================================
  -- code_runner.nvim：コード実行ツール
  -- 様々な言語のコードをNeovim内で即座に実行
  -- =====================================================
  {
    "CRAG666/code_runner.nvim",
    config = function()
      require("code_runner").setup({
        -- 言語別の実行コマンド設定
        filetype = {
          -- コンパイルが必要な言語
          java = "cd $dir && javac $fileName && java $fileNameWithoutExt",  -- コンパイル後実行
          c = "cd $dir && gcc $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
          cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && $dir/$fileNameWithoutExt",
          rust = "cd $dir && rustc $fileName && $dir/$fileNameWithoutExt",

          -- インタープリタ言語（直接実行）
          python = "python3 -u",      -- -u: バッファリング無効（リアルタイム出力）
          javascript = "node",         -- Node.jsで実行
          typescript = "deno run",     -- Denoで実行
          go = "go run",              -- Go言語実行
          php = "php",                -- PHP実行
          lua = "lua",                -- Lua実行
          sh = "bash",                -- シェルスクリプト実行
        },

        -- 実行方法の設定
        mode = "term",                -- ターミナルで実行
        focus = true,                 -- 実行時にターミナルにフォーカス
        startinsert = true,           -- ターミナルを挿入モードで開始

        -- ターミナルウィンドウ設定
        term = {
          position = "bot",           -- 下部に表示
          size = 10,                  -- 高さ10行
        },
      })

      -- キーマップ設定
      vim.keymap.set("n", "<leader>r", ":RunCode<CR>", { desc = "現在のファイルを実行" })
      vim.keymap.set("n", "<leader>rf", ":RunFile<CR>", { desc = "ファイルを選んで実行" })
      vim.keymap.set("n", "<leader>rft", ":RunFile tab<CR>", { desc = "タブで実行" })
      vim.keymap.set("n", "<leader>rp", ":RunProject<CR>", { desc = "プロジェクト全体を実行" })
      vim.keymap.set("n", "<leader>rc", ":RunClose<CR>", { desc = "実行ウィンドウを閉じる" })
    end,
  },

  -- =====================================================
  -- vim-dadbod-ui：データベースクライアント
  -- MySQL、PostgreSQL等をNeovim内で操作
  -- =====================================================
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },  -- データベース操作の基本機能
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },  -- SQL補完
    },
    cmd = {  -- これらのコマンドで遅延読み込み
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- データベースUIの設定
      vim.g.db_ui_use_nerd_fonts = 1           -- Nerdフォントのアイコンを使用
      vim.g.db_ui_show_database_icon = 1       -- データベースアイコンを表示
      vim.g.db_ui_force_echo_notifications = 1 -- 通知を強制表示
      vim.g.db_ui_win_position = "left"        -- 左側にパネル表示
      vim.g.db_ui_winwidth = 40                -- パネル幅40文字

      vim.keymap.set("n", "<leader>db", "<cmd>DBUIToggle<CR>", { desc = "データベース管理UIの開閉" })
    end,
  },
 }