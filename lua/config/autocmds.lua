local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- コピー時に一瞬ハイライトする（どこをコピーしたか分かりやすい）
augroup("YankHighlight", { clear = true })
autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- 保存時に行末の無駄な空白を自動削除
augroup("TrimWhitespace", { clear = true })
autocmd("BufWritePre", {
  group = "TrimWhitespace",
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

-- 新しい行で自動的にコメントを入れない
autocmd("BufEnter", {
  pattern = "*",
  command = "set fo-=c fo-=r fo-=o",
})

-- ウィンドウサイズ変更時に自動調整
autocmd("VimResized", {
  pattern = "*",
  command = "tabdo wincmd =",
})

-- 特定のウィンドウはqキーで閉じられるようにする
autocmd("FileType", {
  pattern = {
    "help",      -- ヘルプ
    "lspinfo",   -- LSP情報
    "man",       -- マニュアル
    "notify",    -- 通知
    "qf",        -- クイックフィックス
    "query",     -- クエリ
    "startuptime", -- 起動時間
    "checkhealth", -- ヘルスチェック
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = event.buf, silent = true })
  end,
})

-- ファイル保存時に存在しないディレクトリを自動作成
autocmd("BufWritePre", {
  pattern = "*",
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Go言語専用：保存時に自動整形とインポート整理
autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format({ async = false })      -- コード整形
    vim.lsp.buf.code_action({                  -- インポート整理
      context = { only = { "source.organizeImports" } },
      apply = true,
    })
  end,
})