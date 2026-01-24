return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  opts = {
    ensure_installed = {
      "markdown",
      "markdown_inline", -- for inline and fenced code blocks
      "bash", "python", "lua", "c", "cpp", "asm", "make", "json", "cmake", "dockerfile", "ninja", "yaml", "toml", "ini", "csv", "javascript", "typescript", "html", "css", "rust", "go", "java", "kotlin", "perl", "ruby", "php", "xml", "regex", "sql", "git_config", "git_rebase", -- add the languages you use in code blocks
    },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = { "markdown" },
    },
  },
}
