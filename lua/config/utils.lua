local utils = {}

function utils.is_plugin_registered(name)
  return require("lazy.core.config").plugins[name] ~= nil
end

-- Fuzzy Picker APIs -----------------------------------------------------------
-- Using these makes keymaps easier to change :)
local fzf = vim.fn["fzf#run"]
local wrap = vim.fn["fzf#wrap"]

local width_full = 0.8
local height_full = 0.8
local width_slim = 0.333333

function utils.cmd_fuzzy_files()
  fzf(wrap({
    window = { width = width_full, height = height_full },
    options = '--preview "bat --color=always --style=plain {}" -m',
  }))
  -- vim.cmd(picker)
end

function utils.cmd_fuzzy_buffers()
  local buf_list = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buflisted then
      local path_abs = vim.api.nvim_buf_get_name(bufnr)
      local path_rel = vim.fn.fnamemodify(path_abs, ":.")
      table.insert(
        buf_list,
        path_rel ~= "" and path_rel or bufnr .. " [No Name]"
      )
    end
  end

  fzf(wrap({
    window = { width = width_slim, height = height_full },
    options = "--accept-nth=1",
    source = buf_list,
    sink = "buffer",
  }))
end

return utils
