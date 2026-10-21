return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",

    config = function()
      require("nvim-treesitter").setup()

      local parsers = {
        "markdown",
        "markdown_inline",
        "bash", "python", "lua", "c", "cpp", "asm",
        "make", "json", "cmake", "dockerfile", "ninja",
        "yaml", "toml", "ini", "csv", "javascript",
        "typescript", "html", "css", "rust", "go", "java",
        "kotlin", "perl", "ruby", "php", "xml", "regex",
        "sql", "git_config", "git_rebase",
      }

      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = parsers,
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
}

