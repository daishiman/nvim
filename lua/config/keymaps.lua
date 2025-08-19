local keymap = vim.keymap

-- より良いエスケープ（jkで挿入モードを抜ける）
keymap.set("i", "jk", "<ESC>", { desc = "挿入モードを終了" })

-- 検索ハイライトを消す
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "検索ハイライトをクリア" })
keymap.set("n", "<Esc>", ":nohl<CR><Esc>", { desc = "ESCで検索ハイライトもクリア" })

-- 削除してもコピーしない（xキーの挙動を変更）
keymap.set("n", "x", '"_x', { desc = "ヤンクせずに削除" })

-- ウィンドウ管理（画面分割）
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "ウィンドウを垂直分割" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "ウィンドウを水平分割" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "分割を均等サイズに" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "現在の分割を閉じる" })

-- ウィンドウ間の移動（<Leader>+hh/jj/kk/ll）
keymap.set("n", "<Leader>hh", "<C-w>h", { desc = "左へ移動" })
keymap.set("n", "<Leader>jj", "<C-w>j", { desc = "下へ移動" })
keymap.set("n", "<Leader>kk", "<C-w>k", { desc = "上へ移動" })
keymap.set("n", "<Leader>ll", "<C-w>l", { desc = "右へ移動" })

-- ウィンドウサイズ変更（Ctrl + 矢印）
keymap.set("n", "<C-Up>", ":resize -2<CR>", { desc = "上にリサイズ" })
keymap.set("n", "<C-Down>", ":resize +2<CR>", { desc = "下にリサイズ" })
keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "左にリサイズ" })
keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "右にリサイズ" })

-- ウィンドウサイズ変更（リーダーキー版）
keymap.set("n", "<leader>sk", ":resize -2<CR>", { desc = "高さを小さく" })
keymap.set("n", "<leader>sj", ":resize +2<CR>", { desc = "高さを大きく" })
keymap.set("n", "<leader>sh", ":vertical resize -2<CR>", { desc = "幅を小さく" })
keymap.set("n", "<leader>sl", ":vertical resize +2<CR>", { desc = "幅を大きく" })

-- タブ操作
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "新しいタブを開く" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "現在のタブを閉じる" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "次のタブ" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "前のタブ" })

-- スクロール時にカーソルを中央に保つ
keymap.set("n", "<C-d>", "<C-d>zz", { desc = "半ページ下移動後にカーソルを中央に" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "半ページ上移動後にカーソルを中央に" })
keymap.set("n", "n", "nzzzv", { desc = "検索結果を中央に" })
keymap.set("n", "N", "Nzzzv", { desc = "検索結果を中央に" })

-- 行を上下に移動（Alt+j/k）
keymap.set("n", "<A-j>", "<cmd>m .+1<CR>==", { desc = "行を下へ移動" })
keymap.set("n", "<A-k>", "<cmd>m .-2<CR>==", { desc = "行を上へ移動" })
keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "選択を下へ移動" })
keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "選択を上へ移動" })

-- インデント後も選択を維持
keymap.set("v", "<", "<gv", { desc = "左へインデント" })
keymap.set("v", ">", ">gv", { desc = "右へインデント" })

-- ペースト時に元のテキストをコピーしない
keymap.set("v", "p", '"_dP', { desc = "ヤンクせずにペースト" })

-- よく使う操作のショートカット
keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "ファイルを保存" })
keymap.set("n", "<leader>wa", "<cmd>wa<CR>", { desc = "全ファイルを保存" })
keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "終了" })
keymap.set("n", "<leader>qa", "<cmd>qa<CR>", { desc = "全て終了" })
