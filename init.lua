ENABLE_NERD_FONTS = true
DIR_JOURNAL = "~/Sync/notes/journal"

require("config.options")
require("config.plugins")
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
else
  require("config.keymaps")
  require("config.autocmds")
end
