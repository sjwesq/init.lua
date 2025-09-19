-- Saving these lines for a rainy day:
-- local is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1
-- local is_mac = vim.fn.has("macunix")
local utils = require("config.utils")

local api = vim.api
local keymap = vim.keymap

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
keymap.set("n", "<C-m>", "gM")

keymap.set("n", "<leader>m", "<Cmd>make<CR>")
keymap.set("n", "<leader>h", "<Cmd>nohl<CR>")
keymap.set("n", "<leader>r", vim.lsp.buf.rename)

-- Set current directory to file
keymap.set("n", "<leader>cd", "<Cmd>cd %:p:h<CR><Cmd>pwd<CR>")

-- Ctrl-S to save
keymap.set("i", "<C-s>", "<Cmd>w<CR>")
keymap.set("n", "<C-s>", "<Cmd>w<CR>")

-- Buffer closing
keymap.set("n", "<M-w>", "<Cmd>bd<CR>")
keymap.set("n", "<M-S-w>", "<Cmd>w|bd<CR>")

-- Quick window navigation
keymap.set("n", "<M-h>", "<Cmd>wincmd h<CR>", { silent = true })
keymap.set("n", "<M-j>", "<Cmd>wincmd j<CR>", { silent = true })
keymap.set("n", "<M-k>", "<Cmd>wincmd k<CR>", { silent = true })
keymap.set("n", "<M-l>", "<Cmd>wincmd l<CR>", { silent = true })
keymap.set("t", "<M-h>", "<Cmd>wincmd h<CR>", { silent = true })
keymap.set("t", "<M-j>", "<Cmd>wincmd j<CR>", { silent = true })
keymap.set("t", "<M-k>", "<Cmd>wincmd k<CR>", { silent = true })
keymap.set("t", "<M-l>", "<Cmd>wincmd l<CR>", { silent = true })

keymap.set("c", "<C-e>", "<End>") -- I think blink breaks this?

-- Firefox-style tab switching
for i = 1, 8 do
  keymap.set("n", "<M-" .. i .. ">", "<Cmd>tabnext " .. i .. "<CR>")
  keymap.set("t", "<M-" .. i .. ">", "<Cmd>tabnext " .. i .. "<CR>")
  keymap.set("i", "<M-" .. i .. ">", "<Cmd>tabnext " .. i .. "<CR>")
end
keymap.set("n", "<M-9>", "<Cmd>tablast<CR>", { silent = true })
keymap.set("t", "<M-9>", "<Cmd>tablast<CR>", { silent = true })
keymap.set("i", "<M-9>", "<Cmd>tablast<CR>", { silent = true })

-- Plugin Bindings ------------------------------------------------------------
if package.loaded["lazy"] then
  if utils.is_plugin_registered("mini.files") then
    keymap.set("n", "<leader>e", MiniFiles.open)
  end

  if utils.is_plugin_registered("mini.pick") then
    keymap.set("n", "<leader>f", MiniPick.builtin.files)
  end

  if utils.is_plugin_registered("nvim-dap") then
    vim.keymap.set("n", "<F5>", function()
      require("dap").continue()
    end)
    vim.keymap.set("n", "<F10>", function()
      require("dap").step_into()
    end)
    vim.keymap.set("n", "<F11>", function()
      require("dap").step_over()
    end)
    vim.keymap.set("n", "<F12>", function()
      require("dap").step_out()
    end)
    vim.keymap.set("n", "<leader>db", function()
      require("dap").toggle_breakpoint()
    end)
    vim.keymap.set("n", "<leader>dB", function()
      require("dap").set_breakpoint()
    end)
    vim.keymap.set("n", "<leader>dl", function()
      require("dap").set_breakpoint(
        nil,
        nil,
        vim.fn.input("Log point message: ")
      )
    end)
    vim.keymap.set("n", "<leader>dr", function()
      require("dap").repl.open()
    end)
    vim.keymap.set("n", "<leader>da", function()
      require("dap").run_last()
    end)
  end

  if utils.is_plugin_registered("nvim-dap-ui") then
    vim.keymap.set("n", "<leader>dv", function()
      require("dapui").toggle()
    end)
  end
  if utils.is_plugin_registered("nvim-tmux-navigation") then
    local nvim_tmux_nav = require("nvim-tmux-navigation")
    keymap.set("n", "<M-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
    keymap.set("n", "<M-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
    keymap.set("n", "<M-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
    keymap.set("n", "<M-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
    keymap.set("n", "<M-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
    keymap.set("n", "<M-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
    keymap.set("t", "<M-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
    keymap.set("t", "<M-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
    keymap.set("t", "<M-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
    keymap.set("t", "<M-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
  end
end

-- blink.cmp has its own keymaps in its setup as well
