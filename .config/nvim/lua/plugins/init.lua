return {
  {
    "stevearc/conform.nvim",
    -- event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
      },
    },
  },

  -- {
  --   "3rd/image.nvim",
  --   lazy = false,
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   config = function()
  --     require("image").setup {
  --       backend = "kitty",
  --     }
  --   end,
  -- },

  {
    "kawre/leetcode.nvim",
    cmd = "Leet",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {},
  },
}

