local utils = {}

function utils.is_plugin_registered(name)
  return require("lazy.core.config").plugins[name] ~= nil
end

-- Fuzzy Picker APIs -----------------------------------------------------------
-- Using these makes keymaps easier to change :)
local fzf = vim.fn["fzfbridge#runwrap"]

local height_normal = 0.8
local win_normal = { width = 0.8, height = height_normal }
local win_slim = { width = 0.333333, height = height_normal }

function utils.fuzzy_files()
  local opts = {
    window = win_normal,
    options = '--preview "bat --color=always --style=plain {}" -m',
  }

  fzf(opts)
end

function utils.fuzzy_buffers()
  local buf_list = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[bufnr].buflisted then
      local path_abs = vim.api.nvim_buf_get_name(bufnr)
      local path_rel = vim.fn.fnamemodify(path_abs, ":.")
      table.insert(
        buf_list,
        path_rel ~= "" and path_rel or bufnr .. " [No Name]"
      )
    end
  end

  local opts = {
    window = win_slim,
    options = "--accept-nth=1",
    source = buf_list,
    sink = "buffer",
  }

  fzf(opts)
end

function utils.fuzzy_help()
  local helptags = {}

  -- Shamelessly lifted from mini.pick
  -- Get all tags
  local help_buf = vim.api.nvim_create_buf(false, true)
  vim.bo[help_buf].buftype = "help"
  -- - NOTE: no dedicated buffer name because it is immediately wiped out
  local tags = vim.api.nvim_buf_call(help_buf, function()
    return vim.fn.taglist(".*")
  end)
  vim.api.nvim_buf_delete(help_buf, { force = true })
  vim.tbl_map(function(t)
    table.insert(helptags, t.name)
  end, tags)

  local opts = {
    window = win_slim,
    source = helptags,
    sink = "help",
  }
  fzf(opts)
end

function utils.fuzzy_live_grep()
  local grep_cmd = "rg --line-number --with-filename --column --smart-case"
  local opts = {
    sink = function(result)
      local args = vim.split(result, " ")
      local filename = args[1]
      local row = tonumber(args[2])
      local column = tonumber(args[3]) - 1

      vim.cmd("e " .. filename)
      vim.api.nvim_win_set_cursor(0, { row, column })
      vim.cmd("norm zz")
    end,
    source = grep_cmd,
    window = win_normal,
    options = "--bind 'change:reload:"
      .. grep_cmd
      .. " {q}' "
      .. "--delimiter='\\:' "
      .. "--nth='3..-1' "
      .. "--accept-nth='{1} {2} {3}' ",
  }
  fzf(opts)
end

return utils
