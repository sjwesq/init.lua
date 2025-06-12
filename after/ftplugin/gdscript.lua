-- after/ftplugin/gdscript.lua
-- Included defaults for gdscript and gdshader don't follow the style guide as
-- strictly as I'd like. So, I fixed it myself.
--
if package.loaded["mini.comment"] then
  vim.b.minicomment_config = {
    -- Options which control module behavior
    options = {
      -- Function to compute custom 'commentstring' (optional)
      custom_commentstring = nil,

      -- Whether to ignore blank lines in actions and textobject
      ignore_blank_line = false,

      -- Whether to recognize as comment only lines without indent
      start_of_line = false,

      -- Whether to force single space inner padding for comment parts
      pad_comment_parts = false,
    },
  }
end

vim.opt_local.expandtab = false
vim.opt_local.fileformat = "unix"
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.bomb = false
