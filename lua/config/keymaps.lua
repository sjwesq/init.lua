-- Saving these lines for a rainy day:
-- local is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1
-- local is_mac = vim.fn.has("macunix")
local utils = require("config.utils")

local api = vim.api
local map = vim.keymap.set

-- Commands -------------------------------------------------------------------

api.nvim_create_user_command("Vimrc", "edit " .. vim.fn.stdpath("config"), {})
api.nvim_create_user_command("Wordify", "g/./,/^$/join", {})
api.nvim_create_user_command("ConformToggle", function()
  vim.g.enable_conform = not vim.g.enable_conform
end, {})

api.nvim_create_user_command("Journal", function()
  local year = os.date("%Y")
  local month = tonumber(os.date("%m"))
  local quarter = "Q" .. math.floor((month - 1) / 3 + 1)
  local dayfile = os.date("%m-%d") .. ".md"

  local dir = string.format("%s/%s/%s", vim.g.dir_journal, year, quarter)
  dir = vim.fn.expand(dir)
  vim.fn.mkdir(dir, "p")

  local path =
    string.format("%s/%s/%s/%s", vim.g.dir_journal, year, quarter, dayfile)
  path = vim.fn.expand(path)
  if vim.fn.filereadable(path) == 0 then
    local header =
      string.format("# %s (%s)", os.date("%Y-%m-%d"), os.date("%A"))
    vim.fn.writefile({ header }, path)
  end
  vim.cmd("edit " .. path)
end, {})

-- For recording
if vim.g.neovide then
  api.nvim_create_user_command("Trans", function()
    vim.g.neovide_opacity = 0.8
    vim.g.neovide_scale_factor = 2.5
  end, {})
end

-- Keymaps --------------------------------------------------------------------
map("n", "<C-m>", "gM")
map("n", "<C-k>", vim.diagnostic.open_float)

map("n", "<leader>m", "<Cmd>make<CR>")
map("n", "<leader>r", vim.lsp.buf.rename)

-- Set current directory to file
map("n", "<leader>cd", "<Cmd>cd %:p:h<CR><Cmd>pwd<CR>")

-- Ctrl-S to save
map("i", "<C-s>", "<Cmd>w<CR>")
map("n", "<C-s>", "<Cmd>w<CR>")

-- Goto end of line quickly
map("i", "<C-l>", "<Esc>A")

-- Function argument update macro
map("n", "<leader>a", "0f(ya(0t(<C-]>0f(va)p<C-o>")

-- Search for yanked string macro
map("n", "<C-n>", '/<C-r>"<CR>')

-- Substitute yanked string macro
map("n", "<leader>s", ':%s/\\V<C-r>"/')

-- Buffer closing
map("n", "<M-w>", "<Cmd>close<CR>")

-- Quick window navigation
map("n", "<M-h>", "<Cmd>wincmd h<CR>", { silent = true })
map("n", "<M-j>", "<Cmd>wincmd j<CR>", { silent = true })
map("n", "<M-k>", "<Cmd>wincmd k<CR>", { silent = true })
map("n", "<M-l>", "<Cmd>wincmd l<CR>", { silent = true })
map("t", "<M-h>", "<Cmd>wincmd h<CR>", { silent = true })
map("t", "<M-j>", "<Cmd>wincmd j<CR>", { silent = true })
map("t", "<M-k>", "<Cmd>wincmd k<CR>", { silent = true })
map("t", "<M-l>", "<Cmd>wincmd l<CR>", { silent = true })

map("c", "<C-e>", "<End>") -- I think blink breaks this?

-- Firefox-style tab switching
for i = 1, 8 do
  map("n", "<M-" .. i .. ">", "<Cmd>tabnext " .. i .. "<CR>")
  map("t", "<M-" .. i .. ">", "<Cmd>tabnext " .. i .. "<CR>")
  map("i", "<M-" .. i .. ">", "<Cmd>tabnext " .. i .. "<CR>")
end
map("n", "<M-9>", "<Cmd>tablast<CR>")
map("t", "<M-9>", "<Cmd>tablast<CR>")
map("i", "<M-9>", "<Cmd>tablast<CR>")

map("n", "<leader>tn", "<Cmd>tabnew<CR>")
map("n", "<leader>tc", "<Cmd>tabclose<CR>")
map("n", "<leader>to", "<Cmd>tabonly<CR>")
map("n", "<leader>tf", function()
  vim.cmd("tabnew")
  utils.fuzzy_files()
end)
map("n", "<leader>tb", function()
  vim.cmd("tabnew")
  utils.fuzzy_buffers()
end)

map("n", "<leader>zf", utils.fuzzy_files)
map("n", "<leader>zb", utils.fuzzy_buffers)
map("n", "<leader>zh", utils.fuzzy_help)
map("n", "<leader>zg", utils.fuzzy_live_grep)

-- Plugin Bindings ------------------------------------------------------------
if package.loaded["lazy"] then
  if utils.is_plugin_registered("mini.files") then
    map("n", "<leader>f", MiniFiles.open)
  end

  if utils.is_plugin_registered("nvim-dap") then
    map("n", "<F5>", function()
      require("dap").continue()
    end)
    map("n", "<F10>", function()
      require("dap").step_into()
    end)
    map("n", "<F11>", function()
      require("dap").step_over()
    end)
    map("n", "<F12>", function()
      require("dap").step_out()
    end)
    map("n", "<leader>db", function()
      require("dap").toggle_breakpoint()
    end)
    map("n", "<leader>dB", function()
      require("dap").set_breakpoint()
    end)
    map("n", "<leader>dl", function()
      require("dap").set_breakpoint(
        nil,
        nil,
        vim.fn.input("Log point message: ")
      )
    end)
    map("n", "<leader>dr", function()
      require("dap").repl.open()
    end)
    map("n", "<leader>da", function()
      require("dap").run_last()
    end)
  end

  if utils.is_plugin_registered("nvim-dap-ui") then
    map("n", "<leader>dv", function()
      require("dapui").toggle()
    end)
  end
  if utils.is_plugin_registered("nvim-tmux-navigation") then
    local nvim_tmux_nav = require("nvim-tmux-navigation")
    map("n", "<M-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
    map("n", "<M-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
    map("n", "<M-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
    map("n", "<M-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
    map("n", "<M-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
    map("n", "<M-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
    map("t", "<M-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
    map("t", "<M-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
    map("t", "<M-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
    map("t", "<M-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
  end
end

-- blink.cmp has its own keymaps in its setup as well
