-- =====================================================
-- Telescope多機能ファインダー設定（オプション）
-- fzf-luaより機能豊富だが動作が重いため、特殊用途向け
-- 通常はfzf-luaで十分なため、デフォルトで無効化
-- =====================================================

-- 無効化する場合は空のテーブルを返す（nilではなく）
local enabled = false

if not enabled then
  -- 無効化時も有効なテーブル構造を返す（エラー防止）
  return {}
end

-- 以下、有効化時の設定
return {
  -- telescope.nvim：拡張性の高いファジーファインダー
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make"
      },
      -- 必要に応じて有効化する拡張機能
      -- "nvim-telescope/telescope-file-browser.nvim",
      -- "nvim-telescope/telescope-project.nvim",
      -- "xiyaowong/telescope-emoji.nvim",
      -- "debugloop/telescope-undo.nvim",
    },
    cmd = "Telescope",    -- :Telescopeコマンドで起動（遅延読み込み）

    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_layout = require("telescope.actions.layout")

      telescope.setup({
        -- =====================================================
        -- デフォルト設定
        -- =====================================================
        defaults = {
          -- プロンプト表示設定
          prompt_prefix = "🔍 ",
          selection_caret = "➤ ",
          entry_prefix = "  ",

          -- 起動時の動作設定
          initial_mode = "insert",
          selection_strategy = "reset",

          -- ソートとレイアウト
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",

          -- レイアウト詳細設定
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },

          -- ファイル無視パターン
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            "dist/",
            "build/",
            "%.lock",
            "%.pdf",
            "%.jpg", "%.jpeg", "%.png",
          },

          -- パス表示
          path_display = { "truncate" },

          -- ウィンドウ設定
          winblend = 0,
          border = {},
          borderchars = {
            "─", "│", "─", "│",
            "╭", "╮", "╯", "╰"
          },
          color_devicons = true,

          -- プレビュー設定
          file_previewer = require("telescope.previewers").vim_buffer_cat.new,
          grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
          qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

          -- キーマップ設定
          mappings = {
            -- 挿入モードのキーマップ
            i = {
              ["<C-n>"] = actions.move_selection_next,
              ["<C-p>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["<C-x>"] = actions.select_horizontal,
              ["<C-v>"] = actions.select_vertical,
              ["<C-t>"] = actions.select_tab,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
              ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<C-f>"] = action_layout.toggle_preview,
            },

            -- ノーマルモードのキーマップ
            n = {
              ["<esc>"] = actions.close,
              ["<CR>"] = actions.select_default,
              ["j"] = actions.move_selection_next,
              ["k"] = actions.move_selection_previous,
              ["H"] = actions.move_to_top,
              ["M"] = actions.move_to_middle,
              ["L"] = actions.move_to_bottom,
              ["gg"] = actions.move_to_top,
              ["G"] = actions.move_to_bottom,
              ["<C-u>"] = actions.preview_scrolling_up,
              ["<C-d>"] = actions.preview_scrolling_down,
              ["?"] = actions.which_key,
              ["<C-f>"] = action_layout.toggle_preview,
            },
          },
        },

        -- =====================================================
        -- 個別ピッカー設定
        -- =====================================================
        pickers = {
          -- ファイル検索設定
          find_files = {
            find_command = {
              "rg",
              "--files",
              "--hidden",
              "--glob", "!**/.git/*"
            },
            hidden = true,
          },

          -- grep検索設定
          live_grep = {
            additional_args = function(opts)
              return { "--hidden" }
            end,
          },

          -- バッファ一覧設定
          buffers = {
            sort_lastused = true,
            theme = "dropdown",
            previewer = false,
            mappings = {
              i = {
                ["<c-d>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
          },
        },

        -- =====================================================
        -- 拡張機能設定
        -- =====================================================
        extensions = {
          -- fzfネイティブ拡張（高速化）
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      -- 拡張機能のロード
      telescope.load_extension("fzf")

      -- =====================================================
      -- キーマップ設定
      -- =====================================================
      local keymap = vim.keymap.set

      -- 基本検索機能
      keymap("n", "<leader>tf", "<cmd>Telescope find_files<cr>",
        { desc = "[Telescope] ファイル検索" })
      keymap("n", "<leader>tg", "<cmd>Telescope live_grep<cr>",
        { desc = "[Telescope] Live grep" })
      keymap("n", "<leader>tb", "<cmd>Telescope buffers<cr>",
        { desc = "[Telescope] バッファ一覧" })
      keymap("n", "<leader>th", "<cmd>Telescope help_tags<cr>",
        { desc = "[Telescope] ヘルプ検索" })
    end,
  },
}