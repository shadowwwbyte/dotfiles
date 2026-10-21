return {
  {
    "nvchad/base46",
    lazy = false,
    config = function()
      local groups = {
        -- Functions
        "@function",
        "@function.call",
        "@function.method",
        "@function.method.call",
        "@constructor",

        -- Keywords
        "@keyword",
        "@keyword.function",
        "@keyword.return",
        "@keyword.operator",
        "@conditional",
        "@repeat",
        "@exception",

        -- Types and structures
        "@type",
        "@type.builtin",
        "@type.definition",
        "@storageclass",
        "@structure",

        -- Constants and literals
        "@constant",
        "@constant.builtin",
        "@boolean",
        "@number",
        "@float",

        -- Important identifiers
        "@property",
        "@field",
        "@attribute",
      }

      for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { bold = true })
      end
    end,
  },
}
