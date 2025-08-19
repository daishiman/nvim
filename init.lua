-- =====================================================
-- Neovim初期化設定
-- 高速起動と効率的なプラグイン管理を実現
-- =====================================================

-- Neovimを高速化する設定（v0.9.0以降のみ）
if vim.loader and vim.loader.enable then
  vim.loader.enable()
end

-- =====================================================
-- リーダーキー設定
-- =====================================================
-- スペースキーをリーダーキーに設定（<leader>でスペースを意味する）
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- =====================================================
-- プラグインマネージャー（lazy.nvim）の自動インストール
-- =====================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  -- lazy.nvimがなければGitHubからダウンロード
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath
  })
  if vim.v.shell_error ~= 0 then
    -- エラーが起きたら表示
    vim.api.nvim_echo({
      { "lazy.nvimのクローンに失敗しました:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\n任意のキーを押して終了..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- =====================================================
-- 各種設定ファイルを読み込み
-- =====================================================
require("config.options")    -- エディタの基本設定
require("config.keymaps")    -- キーボードショートカット
require("config.autocmds")   -- 自動実行コマンド

-- =====================================================
-- ディレクトリ自動表示設定（プラグイン読み込み前に準備）
-- =====================================================
-- グローバル変数でディレクトリ情報を保存
vim.g.nvim_tree_should_open = false
vim.g.nvim_tree_target_dir = vim.fn.getcwd()

-- 引数がディレクトリの場合は記録
if vim.fn.argc() > 0 then
  local arg = vim.fn.argv(0)
  if arg == "." or vim.fn.isdirectory(arg) == 1 then
    vim.g.nvim_tree_should_open = true
    if arg == "." then
      vim.g.nvim_tree_target_dir = vim.fn.getcwd()
    else
      vim.g.nvim_tree_target_dir = vim.fn.fnamemodify(arg, ":p")
    end
  end
end
require("config.lsp-keymaps") -- LSPキーマップ設定

-- =====================================================
-- プラグインマネージャーを起動（最適化設定付き）
-- =====================================================
require("lazy").setup({
  -- プラグインの読み込み設定
  spec = {
    -- pluginsディレクトリから全プラグインを読み込み
    -- search-init.lua, search-finder.lua, search-motion.lua,
    -- search-replace.lua, search-telescope.lua も含まれる
    { import = "plugins" },

    -- LSP関連プラグインを読み込み
    { import = "plugins.lsp" },

    -- 検索機能プラグインを明示的に読み込み（オプション）
    -- pluginsディレクトリ直下に配置する場合は上記で自動読み込みされるため不要
    -- 別ディレクトリ（plugins.search）に配置する場合は以下をコメントアウト解除
    -- { import = "plugins.search" },
  },

  -- デフォルト設定
  defaults = {
    lazy = true,                   -- プラグインを遅延読み込み（高速化）
    version = false,               -- 最新版を使用
  },

  -- インストール設定
  install = {
    -- インストール時に使用するカラーテーマ
    colorscheme = { "tokyonight", "catppuccin" },
  },

  -- 更新チェック設定
  checker = {
    enabled = true,                -- 更新チェックを有効化
    notify = false,                -- 更新通知はオフ（静かに動作）
    frequency = 86400,             -- 1日1回チェック（86400秒 = 24時間）
  },

  -- パフォーマンス最適化設定
  performance = {
    cache = {
      enabled = true,              -- キャッシュで高速化
    },
    reset_packpath = true,         -- packpathをリセット
    rtp = {
      reset = true,                -- runtimepathをリセット
      -- 使わない標準プラグインを無効化（起動速度向上）
      disabled_plugins = {
        "gzip",                    -- gzipファイル対応
        "matchit",                 -- %での移動拡張
        "matchparen",              -- 括弧のマッチ表示
        "netrwPlugin",             -- ファイルエクスプローラー
        "tarPlugin",               -- tarファイル対応
        "tohtml",                  -- HTMLエクスポート
        "tutor",                   -- vimtutor
        "zipPlugin",               -- zipファイル対応
      },
    },
  },
})