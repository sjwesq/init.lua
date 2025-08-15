-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.options")
require("config.lazy")
require("config.override")

-- Lazy load the rest
if package.loaded["lazy"] then
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      require("config.keymaps")
      require("config.autocmds")
    end,
  })
end
