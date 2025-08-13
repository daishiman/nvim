-- =====================================================
-- LSPキーマップ設定
-- Language Server Protocol関連のキーボードショートカット
-- =====================================================

local M = {}

-- =====================================================
-- LSPアタッチ時の設定
-- =====================================================
M.on_attach = function(client, bufnr)
  local opts = { buffer = bufnr }

  -- =====================================================
  -- コードナビゲーション（移動系）
  -- =====================================================
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
    vim.tbl_extend("force", opts, { desc = "宣言へ移動" }))

  vim.keymap.set("n", "gd", vim.lsp.buf.definition,
    vim.tbl_extend("force", opts, { desc = "定義へ移動" }))

  vim.keymap.set("n", "K", vim.lsp.buf.hover,
    vim.tbl_extend("force", opts, { desc = "ホバー情報（詳細表示）" }))

  vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
    vim.tbl_extend("force", opts, { desc = "実装へ移動" }))

  vim.keymap.set("n", "gr", vim.lsp.buf.references,
    vim.tbl_extend("force", opts, { desc = "参照箇所を表示" }))

  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition,
    vim.tbl_extend("force", opts, { desc = "型定義へ移動" }))

  -- =====================================================
  -- コードアクション（変更系）
  -- =====================================================
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,
    vim.tbl_extend("force", opts, { desc = "名前を変更" }))

  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
    vim.tbl_extend("force", opts, { desc = "コードアクション（自動修正）" }))

  vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, vim.tbl_extend("force", opts, { desc = "コード整形" }))

  -- =====================================================
  -- エラー診断
  -- =====================================================
  vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float,
    vim.tbl_extend("force", opts, { desc = "エラー詳細を表示" }))

  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,
    vim.tbl_extend("force", opts, { desc = "前のエラーへ" }))

  vim.keymap.set("n", "]d", vim.diagnostic.goto_next,
    vim.tbl_extend("force", opts, { desc = "次のエラーへ" }))

  vim.keymap.set("n", "<leader>dl", vim.diagnostic.setloclist,
    vim.tbl_extend("force", opts, { desc = "エラー一覧" }))

  -- =====================================================
  -- インサートモードのヘルプ
  -- =====================================================
  vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help,
    vim.tbl_extend("force", opts, { desc = "引数ヘルプ" }))

  -- =====================================================
  -- ワークスペース管理
  -- =====================================================
  vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder,
    vim.tbl_extend("force", opts, { desc = "フォルダを追加" }))

  vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder,
    vim.tbl_extend("force", opts, { desc = "フォルダを削除" }))

  vim.keymap.set("n", "<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, vim.tbl_extend("force", opts, { desc = "フォルダ一覧" }))
end

-- =====================================================
-- 自動コマンドの設定
-- =====================================================
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    -- バッファローカルのキーマップを設定
    M.on_attach(ev.client, ev.buf)

    -- インレイヒントの設定（対応している場合）
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.server_capabilities.inlayHintProvider then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end
  end,
})

-- =====================================================
-- 診断表示の設定
-- =====================================================
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",           -- エラー表示の記号
    source = "if_many",     -- 複数ソースがある場合のみ表示
    spacing = 4,            -- テキストとの間隔
  },
  float = {
    source = "always",      -- 常にソースを表示
    border = "rounded",     -- 角丸の枠
    header = "",           -- ヘッダーを空に
    prefix = "",           -- プレフィックスを空に
  },
  signs = true,            -- 左端にアイコン表示
  underline = true,        -- エラー箇所に下線
  update_in_insert = false, -- 挿入モードでは更新しない
  severity_sort = true,    -- 重要度順に並べる
})

-- =====================================================
-- エラーレベル別のアイコン設定
-- =====================================================
local signs = {
  Error = " ",  -- エラー
  Warn = " ",   -- 警告
  Hint = " ",   -- ヒント
  Info = " "    -- 情報
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, {
    text = icon,
    texthl = hl,
    numhl = hl
  })
end

-- =====================================================
-- グローバルキーマップ（LSP未アタッチ時も使用可能）
-- =====================================================
vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist,
  { desc = "診断をQuickfixリストに送信" })

vim.keymap.set("n", "<leader>D", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "診断の表示を切り替え" })

-- モジュールを返す（lazy.nvimの要求）
return M