local opt = vim.opt

-- 行番号の表示設定
opt.relativenumber = true  -- カーソル位置からの相対行番号
opt.number = true          -- 現在行の絶対行番号

-- タブとインデント（字下げ）の設定
opt.tabstop = 2           -- タブ文字の幅
opt.shiftwidth = 2        -- 自動インデントの幅
opt.expandtab = true      -- タブをスペースに変換
opt.autoindent = true     -- 前の行と同じインデント
opt.smartindent = true    -- 賢いインデント（括弧など考慮）

-- 行の折り返し
opt.wrap = true           -- 長い行を折り返す

-- 検索の設定
opt.ignorecase = true     -- 大文字小文字を区別しない
opt.smartcase = true      -- 大文字が含まれたら区別する
opt.hlsearch = true       -- 検索結果をハイライト
opt.incsearch = true      -- 入力中に検索

-- カーソル行
opt.cursorline = true     -- 現在行を強調表示

-- 見た目の設定
opt.termguicolors = true  -- 24ビットカラー対応
opt.background = "dark"   -- ダークテーマ
opt.signcolumn = "yes"    -- 左端に記号用の列を常に表示
opt.colorcolumn = "120"   -- 120文字目に縦線（長すぎる行の目安）

-- バックスペース
opt.backspace = "indent,eol,start"  -- バックスペースで何でも削除可能

-- クリップボード
opt.clipboard:append("unnamedplus")  -- システムのクリップボードと連携

-- ウィンドウ分割
opt.splitright = true     -- 垂直分割は右に開く
opt.splitbelow = true     -- 水平分割は下に開く

-- 単語の定義
opt.iskeyword:append("-") -- ハイフンも単語の一部として扱う

-- ファイル管理
opt.swapfile = false      -- スワップファイルを作らない
opt.backup = false        -- バックアップファイルを作らない
opt.undofile = true       -- アンドゥ履歴を保存
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"  -- アンドゥ履歴の保存先

-- スクロール設定
opt.scrolloff = 8         -- 上下に最低8行表示
opt.sidescrolloff = 8     -- 左右に最低8文字表示

-- 応答速度の設定
opt.updatetime = 50       -- 更新間隔（ミリ秒）
opt.timeoutlen = 300      -- キー入力の待機時間

-- 補完メニュー
opt.completeopt = "menuone,noselect"  -- 補完メニューの動作設定

-- シェル設定（起動高速化）
if vim.fn.executable("zsh") == 1 then
  opt.shell = "zsh"       -- zshがあれば使用
end

-- セッション設定
opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- パフォーマンス設定
opt.lazyredraw = true     -- マクロ実行中は画面を更新しない
opt.redrawtime = 1500     -- 再描画のタイムアウト
