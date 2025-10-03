local utils = {}

function utils.is_plugin_registered(name)
  return require("lazy.core.config").plugins[name] ~= nil
end

-- Fuzzy Picker APIs -----------------------------------------------------------
-- Using these makes keymaps easier to change :)
local pck_layout_normal = "'window':{'width':0.8, 'height':0.8}, "
local pck_layout_slim = "'window':{'width':0.333, 'height':0.8}, "

local function cmd_close(str)
  return "<Cmd>" .. str .. "<CR>"
end

function utils.cmd_fuzzy_files()
  local picker = "call fzf#run(fzf#wrap({"
    .. pck_layout_normal
    .. "'options':'--preview \"bat --color=always --style=plain {}\" -m', "
    .. "}))"

  vim.cmd(picker)
end
function utils.cmd_fuzzy_buffers()
  local picker = "call fzf#run(fzf#wrap({"
    .. pck_layout_slim
    .. "'source': map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'), "
    .. "'sink': 'buffer', "
    .. "}))"

  vim.cmd(picker)
end

return utils
