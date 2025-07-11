return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- lua stuff
        "lua-language-server",
        "stylua",

        -- web dev stuff
        "css-lsp",
        "html-lsp",
        "typescript-language-server", -- Add this for tsserver
        "deno",
        "prettier",

        -- c/cpp stuff
        "clangd",
        "clang-format",
      },
    },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        -- lua stuff
        "lua_ls",

        -- web dev stuff
        "cssls",
        "html",
        "tsserver", -- Add this for tsserver
        "denols",

        -- c/cpp stuff
        "clangd",
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "typescript-language-server", -- Add this for tsserver
      },
    },
  },
} 