require "nvchad.autocmds"

require "nvchad.autocmds"

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
  callback = function()
    vim.schedule(function()
      local ok, image = pcall(require, "image")
      if ok then
        image.clear()
        image.from_file(vim.fn.expand("%"), {
          window = vim.api.nvim_get_current_win(),
        })
      end
    end)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "c", "cpp", "java" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.expandtab = true
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "lua", "json", "css", "html" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true
  end,
})

