-- require("nvchad.configs.lspconfig").defaults()
--
-- local servers = { "html", "cssls" }
-- vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 

-- NvChad defaults
require("nvchad.configs.lspconfig").defaults()

local nvlsp = require("nvchad.configs.lspconfig")

-- custom on_attach (with your keymaps)
local function on_attach(client, bufnr)
  nvlsp.on_attach(client, bufnr)

  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
end

-- register configs in the new API
vim.lsp.config("*", {
  on_attach = on_attach,
  capabilities = nvlsp.capabilities,
})

-- enable servers
vim.lsp.enable({
  "html",
  "cssls",
  "bashls",
  "tsserver",
  "clangd",
  "pylsp",
  "rust_analyzer",
  "jdtls",
})

-- per-server overrides (new API)
vim.lsp.config("clangd", {
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp" },
})

vim.lsp.config("pylsp", {
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          enabled = true,
          ignore = { "E501" },
          maxLineLength = 88,
        },
        pylsp_mypy = { enabled = true, live_mode = false },
        pylsp_black = { enabled = true },
        pyls_isort = { enabled = true },
      },
    },
  },
})

vim.lsp.config("rust_analyzer", {
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = { command = "clippy" },
    },
  },
})

vim.lsp.config("jdtls", {
  root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }),
})

