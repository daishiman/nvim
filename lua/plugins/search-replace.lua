-- =====================================================
-- プロジェクト全体の検索置換
-- spectre.nvimによるビジュアルな一括置換機能
-- =====================================================

return {
  -- nvim-spectre: VSCodeのような検索置換UI
  -- sed/ripgrepを使用した強力な置換機能
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      "nvim-lua/plenary.nvim",  -- Neovim用の便利な関数ライブラリ
    },
    -- 遅延読み込み(コマンド実行時のみ)
    cmd = { "Spectre" },

    -- キーマップ設定
    keys = {
      -- =====================================================
      -- 基本的な起動キー
      -- =====================================================
      {
        "<leader>S",  -- Space + Shift + S
        function() require("spectre").toggle() end,
        desc = "Spectreを開く(プロジェクト全体の検索置換)"
      },

      {
        "<leader>sw",  -- Space + s + w (word)
        function()
          require("spectre").open_visual({ select_word = true })
        end,
        desc = "カーソル下の単語を検索置換"
      },

      {
        "<leader>sw",  -- Visual modeでSpace + s + w
        mode = "v",
        function()
          require("spectre").open_visual()
        end,
        desc = "選択テキストを検索置換"
      },

      {
        "<leader>sp",  -- Space + s + p (page/file)
        function()
          require("spectre").open_file_search({ select_word = true })
        end,
        desc = "現在ファイル内で検索置換"
      },
    },

    config = function()
      require("spectre").setup({
        -- =====================================================
        -- 基本設定
        -- =====================================================
        color_devicons = true,      -- カラーアイコン表示(ファイルタイプ識別)
        open_cmd = "vnew",          -- 開き方(vnew=垂直分割, new=水平分割, tabnew=新規タブ)
        live_update = false,        -- リアルタイム更新(重い場合は無効推奨)

        -- =====================================================
        -- UI表示設定
        -- 検索結果の見た目をカスタマイズ
        -- =====================================================
        line_sep_start = "┌─────────────────────────────────────────",
        result_padding = "¦  ",     -- 結果のインデント
        line_sep = "└─────────────────────────────────────────",

        -- ハイライトグループ設定
        highlight = {
          ui = "String",            -- UIテキストの色
          search = "DiffChange",    -- 検索マッチの色
          replace = "DiffDelete",   -- 置換テキストの色
        },

        -- =====================================================
        -- キーマッピング設定
        -- Spectreバッファ内での操作
        -- =====================================================
        mapping = {
          -- 行の除外/含める切替
          ["toggle_line"] = {
            map = "dd",            -- vimの削除と同じキー
            cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
            desc = "この行を置換対象から除外/含める"
          },

          -- ファイルを開く
          ["enter_file"] = {
            map = "<cr>",          -- Enterキー
            cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
            desc = "選択したファイルを開く"
          },

          -- Quickfixに送る
          ["send_to_qf"] = {
            map = "<leader>q",
            cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
            desc = "検索結果をQuickfixリストに送る"
          },

          -- 置換コマンド入力
          ["replace_cmd"] = {
            map = "<leader>c",
            cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
            desc = "置換コマンドを入力"
          },

          -- オプション表示
          ["show_option_menu"] = {
            map = "<leader>o",
            cmd = "<cmd>lua require('spectre').show_options()<CR>",
            desc = "オプションメニューを表示"
          },

          -- 現在行のみ置換
          ["run_current_replace"] = {
            map = "<leader>rc",    -- replace current
            cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
            desc = "カーソル行のみ置換実行"
          },

          -- 全て置換(危険！確認推奨)
          ["run_replace"] = {
            map = "<leader>R",     -- 大文字Rで実行(誤操作防止)
            cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
            desc = "【注意】全ての置換を実行"
          },

          -- ビューモード変更
          ["change_view_mode"] = {
            map = "<leader>v",
            cmd = "<cmd>lua require('spectre').change_view()<CR>",
            desc = "表示モードを変更"
          },

          -- 置換エンジンの切替(sed/oxi)
          ["change_replace_sed"] = {
            map = "trs",           -- toggle replace sed
            cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
            desc = "置換エンジンをsedに変更"
          },
          ["change_replace_oxi"] = {
            map = "tro",           -- toggle replace oxi
            cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
            desc = "置換エンジンをoxiに変更"
          },

          -- ライブ更新切替
          ["toggle_live_update"] = {
            map = "tu",            -- toggle update
            cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
            desc = "リアルタイム更新の切替"
          },

          -- 大文字小文字の無視切替
          ["toggle_ignore_case"] = {
            map = "ti",            -- toggle ignore
            cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
            desc = "大文字小文字の区別を切替"
          },

          -- 隠しファイルの表示切替
          ["toggle_ignore_hidden"] = {
            map = "th",            -- toggle hidden
            cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
            desc = "隠しファイルの表示を切替"
          },

          -- 最後の検索を再開
          ["resume_last_search"] = {
            map = "<leader>l",     -- last
            cmd = "<cmd>lua require('spectre').resume_last_search()<CR>",
            desc = "最後の検索を再開"
          },
        },

        -- =====================================================
        -- 検索エンジン設定(ripgrep)
        -- =====================================================
        find_engine = {
          ["rg"] = {
            cmd = "rg",            -- ripgrepコマンド
            args = {
              "--color=never",     -- 色なし(パース用)
              "--no-heading",      -- ヘッダーなし
              "--with-filename",   -- ファイル名表示
              "--line-number",     -- 行番号表示
              "--column",          -- 列番号表示
            },
            options = {
              -- 大文字小文字を無視
              ["ignore-case"] = {
                value = "--ignore-case",
                icon = "[I]",
                desc = "大文字小文字を無視"
              },
              -- 隠しファイルを含む
              ["hidden"] = {
                value = "--hidden",
                icon = "[H]",
                desc = "隠しファイルを含む"
              },
              -- 単語境界で検索
              ["word-regexp"] = {
                value = "--word-regexp",
                icon = "[W]",
                desc = "単語単位で検索"
              },
            },
          },
        },

        -- =====================================================
        -- 置換エンジン設定
        -- =====================================================
        replace_engine = {
          -- sed(標準的なUnixツール)
          ["sed"] = {
            cmd = "sed",
            args = nil,            -- OSによって異なるため自動設定
            options = {
              ["ignore-case"] = {
                value = "--ignore-case",
                icon = "[I]",
                desc = "大文字小文字を無視"
              },
            },
          },
          -- oxi(Rust製の高速置換ツール、要インストール)
          ["oxi"] = {
            cmd = "oxi",
            args = nil,
            options = {},
          },
        },

        -- =====================================================
        -- デフォルト設定
        -- =====================================================
        default = {
          find = {
            cmd = "rg",           -- デフォルトはripgrep
            options = { "ignore-case" },  -- デフォルトで大文字小文字無視
          },
          replace = {
            cmd = "sed",          -- デフォルトはsed
          },
        },

        -- その他の設定
        replace_vim_cmd = "cdo",    -- Vimの置換コマンド(cdo/cfdo)
        is_open_target_win = true,  -- ターゲットウィンドウを開く
        is_insert_mode = false,     -- 起動時に挿入モードにしない
      })
    end,
  },
}