-- =====================================================
-- Treesitter設定
-- 構文解析によるより正確なシンタックスハイライトと
-- コード理解機能を提供する
-- =====================================================

return {
  -- nvim-treesitter：高度なシンタックスハイライト
  -- 🚨 一時的に無効化（アーキテクチャ問題のため）
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = false,  -- 一時的に無効化
    build = function()
      -- アーキテクチャの問題を解決するため、強制的に再コンパイル
      vim.cmd("TSUpdate")
      vim.cmd("TSInstall! lua javascript typescript python go rust json yaml markdown")
    end,
    event = { "BufReadPost", "BufNewFile" },  -- ファイルを開いた時に読み込み
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",  -- テキストオブジェクト（関数やクラスなど）を拡張
      "windwp/nvim-ts-autotag",  -- HTMLタグを自動で閉じる
      "nvim-treesitter/nvim-treesitter-context",  -- 画面上部に現在のコンテキスト（関数名など）を表示
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- 自動インストールする言語パーサーのリスト（アーキテクチャ問題回避のため基本的なもののみ）
        ensure_installed = {
          -- 基本的な言語のみ自動インストール
          "lua",           -- Neovim設定用
          "vim",           -- Vimscript
          "vimdoc",        -- Vimドキュメント
          "query",         -- Treesitterクエリ
        },

        -- 追加言語は手動インストール推奨（アーキテクチャ問題回避）
        -- 手動インストール方法:
        -- :TSInstall javascript typescript python go rust json yaml markdown
        -- 
        -- ensure_installed_manual = {
        --   "bash", "c", "css", "dockerfile", "go", "gomod", "gosum", 
        --   "html", "javascript", "json", "jsonc", "luadoc", "luap", 
        --   "markdown", "markdown_inline", "python", "regex", "toml", 
        --   "tsx", "typescript", "yaml", "rust"
        -- },

        -- 自動インストールを無効化（アーキテクチャ問題回避）
        auto_install = false,

        -- シンタックスハイライトの設定
        highlight = {
          enable = true,  -- ハイライトを有効化
          additional_vim_regex_highlighting = false,  -- Vimの正規表現ハイライトは無効（高速化）
        },

        -- インデント機能
        indent = {
          enable = true,  -- Treesitterベースのインデントを有効化
        },

        -- HTMLタグ自動閉じ機能
        autotag = {
          enable = true,  -- <div>と入力したら</div>を自動追加
        },

        -- インクリメンタル選択（徐々に選択範囲を広げる）
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-space>",     -- Ctrl+Spaceで選択開始
            node_incremental = "<C-space>",   -- 再度押すと選択範囲を拡大
            scope_incremental = false,        -- スコープ単位の拡大は無効
            node_decremental = "<bs>",        -- Backspaceで選択範囲を縮小
          },
        },

        -- テキストオブジェクト（vifで関数内を選択など）
        textobjects = {
          select = {
            enable = true,
            lookahead = true,  -- カーソル位置から前方を検索
            keymaps = {
              ["af"] = "@function.outer",  -- 関数全体を選択（a function）
              ["if"] = "@function.inner",  -- 関数内部を選択（inner function）
              ["ac"] = "@class.outer",     -- クラス全体を選択
              ["ic"] = "@class.inner",     -- クラス内部を選択
              ["al"] = "@loop.outer",      -- ループ全体を選択
              ["il"] = "@loop.inner",      -- ループ内部を選択
            },
          },
          -- コード内の移動
          move = {
            enable = true,
            set_jumps = true,  -- ジャンプリストに追加
            goto_next_start = {
              ["]m"] = "@function.outer",  -- 次の関数の開始位置へ
              ["]]"] = "@class.outer",     -- 次のクラスの開始位置へ
            },
            goto_next_end = {
              ["]M"] = "@function.outer",  -- 次の関数の終了位置へ
              ["]["] = "@class.outer",     -- 次のクラスの終了位置へ
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",  -- 前の関数の開始位置へ
              ["[["] = "@class.outer",     -- 前のクラスの開始位置へ
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",  -- 前の関数の終了位置へ
              ["[]"] = "@class.outer",     -- 前のクラスの終了位置へ
            },
          },
        },
      })

      -- コンテキスト表示の設定（画面上部に現在の関数名などを固定表示）
      require("treesitter-context").setup({
        enable = true,      -- 機能を有効化
        max_lines = 3,      -- 最大3行まで表示
      })
    end,
  },
}