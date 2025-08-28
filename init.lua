vim.g.enable_nerd_fonts = true
vim.g.dir_journal = "~/Sync/notes/journal"

require("config.options")
require("config.plugins")

-- Lazy load the rest
if package.loaded["lazy"] then
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      require("config.keymaps")
      require("config.autocmds")
      require("config.override")
    end,
  })
else
  require("config.keymaps")
  require("config.autocmds")
  require("config.override")
end
