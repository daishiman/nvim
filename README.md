# 🚀 私のNeovim設定

高速で強力な現代的Neovim設定です。Lazy.nvimを使用した効率的なプラグイン管理と、LSP、自動補完、Git統合などを含む包括的な開発環境を提供します。

## ✨ 主な機能

### 🎨 UI・テーマ
- **TokyoNight** - 美しく読みやすいカラーテーマ
- **Lualine** - 情報豊富なステータスライン
- **Oil.nvim** - 革新的なファイルエクスプローラー
- **Which-key** - キーマップのヘルプ表示
- **Dashboard** - スタイリッシュなスタート画面

### 🔍 検索・ナビゲーション
- **FZF-Lua** - 高速ファジーファインダー
- **Telescope** - 強力な検索・プレビュー機能
- **Hop.nvim** - 高速テキストナビゲーション

### 💻 開発サポート
- **LSP** - 多言語対応の言語サーバー
  - TypeScript/JavaScript (vtsls)
  - Python (basedpyright)
  - Go (gopls)
  - Lua (lua_ls)
  - Rust (rust_analyzer)
- **自動補完** (nvim-cmp)
- **シンタックスハイライト** (Treesitter)
- **コード整形** (Prettier, Black, など)

### 🔧 Git統合
- **Gitsigns** - リアルタイム差分表示
- **Neogit** - Magitスタイルのgitインターフェース
- **Diffview** - 高機能な差分ビューワー

## 🛠️ インストール方法

```bash
# バックアップ（必要に応じて）
mv ~/.config/nvim ~/.config/nvim.backup

# このリポジトリをクローン
git clone <リポジトリURL> ~/.config/nvim

# Neovimを起動（プラグインが自動インストールされます）
nvim
```

## ⌨️ 主要キーマップ

### リーダーキー: `Space`

#### ファイル操作
- `<leader>e` - ファイルエクスプローラー（フロート）
- `<leader>ff` - ファイル検索
- `<leader>fg` - テキスト検索
- `-` - 親ディレクトリを開く

#### Git操作
- `<leader>gg` - Neogit メインパネル
- `<leader>gd` - 差分表示
- `<leader>gb` - Blame表示切り替え

#### LSP機能
- `gd` - 定義へ移動
- `gr` - 参照表示
- `K` - ホバー情報
- `<leader>ca` - コードアクション

## 📁 ディレクトリ構造

```
~/.config/nvim/
├── init.lua              # エントリーポイント
├── lazy-lock.json        # プラグインバージョン固定
├── lua/
│   ├── config/           # 基本設定
│   │   ├── options.lua   # Neovimオプション
│   │   ├── keymaps.lua   # キーマップ
│   │   └── autocmds.lua  # 自動コマンド
│   └── plugins/          # プラグイン設定
│       ├── ui.lua        # UI関連
│       ├── lsp/          # LSP設定
│       ├── completion.lua # 補完設定
│       └── ...
├── after/
│   └── ftplugin/         # ファイルタイプ固有設定
└── README.md             # このファイル
```

## 🔧 カスタマイズ

`CLAUDE.md`ファイルに詳細な設定説明があります。個人的な設定変更は各プラグイン設定ファイルを編集してください。

## 📋 必要環境

- Neovim >= 0.9.0
- Git
- Node.js (LSP用)
- Python 3.x (LSP用)
- 各種言語のツール（オプション）

## 🤝 貢献

改善提案やバグ報告はIssueでお知らせください。

---

⚡ **高速起動、強力な機能、美しいUI** を追求したNeovim設定です！# nvim
