return {
  -- 自動補完エンジン
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",  -- 挿入モードで読み込み
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",      -- LSPからの補完
    "hrsh7th/cmp-buffer",        -- バッファ内の単語補完
    "hrsh7th/cmp-path",          -- ファイルパス補完
    "hrsh7th/cmp-cmdline",       -- コマンドライン補完
    "saadparwaiz1/cmp_luasnip",  -- スニペット補完
    "L3MON4D3/LuaSnip",          -- スニペットエンジン
    "rafamadriz/friendly-snippets",  -- よく使うスニペット集
    "onsails/lspkind.nvim",      -- アイコン表示
  },
  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    -- VSCodeスタイルのスニペットを読み込み
    require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup({
      -- スニペット設定
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      -- キーマッピング
      mapping = cmp.mapping.preset.insert({
        ["<C-k>"] = cmp.mapping.select_prev_item(),      -- 前の候補
        ["<C-j>"] = cmp.mapping.select_next_item(),      -- 次の候補
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),         -- ドキュメントを上スクロール
        ["<C-f>"] = cmp.mapping.scroll_docs(4),          -- ドキュメントを下スクロール
        ["<C-Space>"] = cmp.mapping.complete(),          -- 補完メニューを開く
        ["<C-e>"] = cmp.mapping.abort(),                 -- 補完をキャンセル
        ["<CR>"] = cmp.mapping.confirm({ select = false }), -- 選択を確定

        -- Tabキーで補完を進める
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),

        -- Shift+Tabで戻る
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),

      -- 補完ソースの優先順位
      sources = cmp.config.sources({
        { name = "nvim_lsp", priority = 1000 },  -- LSPが最優先
        { name = "luasnip", priority = 750 },    -- スニペット
        { name = "buffer", priority = 500 },     -- バッファ内の単語
        { name = "path", priority = 250 },       -- ファイルパス
      }),

      -- 見た目の設定
      formatting = {
        format = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
          before = function(entry, vim_item)
            -- 補完ソースを表示
            vim_item.menu = ({
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              buffer = "[Buffer]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        }),
      },

      -- ゴーストテキスト（薄く表示される補完候補）
      experimental = {
        ghost_text = true,
      },
    })

    -- 検索時の補完（/と?）
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- コマンドラインの補完（:）
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })
  end,
}