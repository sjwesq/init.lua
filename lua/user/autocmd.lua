-- lua/user/autocmd.lua
local utils = require("user.utils")

-- Remove all trailing whitespace on save
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  callback = function()
    local save_cursor = vim.fn.getpos(".")
    pcall(function() vim.cmd([[%s/\s\+$//e]]) end)
    vim.fn.setpos(".", save_cursor)
  end,
})

vim.o.updatetime = 300 -- delay before showing hover
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = "rounded",
      source = "always",
      prefix = "",
      scope = "line",
    })
  end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function() vim.opt_local.spell = false end,
})

-- Enter insert mode when switching to terminal tab
vim.api.nvim_create_autocmd({ "TabEnter" }, {
  pattern = "term://*",
  callback = function()
    if #vim.api.nvim_tabpage_list_wins(0) == 1 then
      vim.cmd("startinsert")
    else
      vim.cmd("stopinsert")
    end
  end,
})

-- Plugin autocmds ------------------------------------------------------------
if package.loaded["lazy"] then
  if utils.is_plugin_registered("nvim-lint") then
    vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost" }, {
      callback = function()
        local lint_status, lint = pcall(require, "lint")
        if lint_status then lint.try_lint() end
      end,
    })
  end

  -- Restore macro notifications
  if utils.is_plugin_registered("nvim-notify") then
    vim.api.nvim_create_autocmd("RecordingEnter", {
      callback = function()
        local reg = vim.fn.reg_recording()
        require("notify")(
          "Recording macro @" .. reg,
          "info",
          { title = "Macro", timeout = 1000 }
        )
      end,
    })

    vim.api.nvim_create_autocmd("RecordingLeave", {
      callback = function()
        require("notify")(
          "Stopped recording",
          "info",
          { title = "Macro", timeout = 700 }
        )
      end,
    })
  end
end
