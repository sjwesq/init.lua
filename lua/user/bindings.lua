-- lua/user/bindings.lua
-- Saving these lines for a rainy day:
-- local is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1
-- local is_mac = vim.fn.has("macunix")
local utils = require("user.utils")

local api = vim.api
local keymap = vim.keymap

-- Commands -------------------------------------------------------------------

api.nvim_create_user_command("Vimrc", "edit " .. vim.fn.stdpath("config"), {})

-- For recording
if vim.g.neovide then
  api.nvim_create_user_command("Trans", function()
    vim.g.neovide_opacity = 0.8
    vim.g.neovide_scale_factor = 2.5
  end, {})
end

-- Keymaps --------------------------------------------------------------------

-- Remove search highlight
keymap.set("n", "<leader>h", "<Cmd>nohl<CR>")

-- Set current directory to file
keymap.set("n", "<leader>d", "<Cmd>cd %:p:h<CR><Cmd>pwd<CR>")

-- Ctrl-S to save
keymap.set("i", "<C-s>", "<Cmd>w<CR>")
keymap.set("n", "<C-s>", "<Cmd>w<CR>")

-- Buffer closing
keymap.set("n", "<M-w>", "<Cmd>bd<CR>")
keymap.set("n", "<M-S-w>", "<Cmd>w|bd<CR>")

-- Quick window navigation
keymap.set("n", "<C-h>", "<Cmd>wincmd h<CR>", { silent = true })
keymap.set("n", "<C-j>", "<Cmd>wincmd j<CR>", { silent = true })
keymap.set("n", "<C-k>", "<Cmd>wincmd k<CR>", { silent = true })
keymap.set("n", "<C-l>", "<Cmd>wincmd l<CR>", { silent = true })

keymap.set("c", "<C-e>", "<End>") -- I think blink breaks this?

-- Plugin Bindings ------------------------------------------------------------
-- Firefox-style tab switching
if package.loaded["lazy"] then
  if utils.is_plugin_registered("bufferline.nvim") then
    for i = 1, 8 do
      keymap.set("n", "<M-" .. i .. ">", "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>", { silent = true })
    end
    keymap.set("n", "<M-9>", "<Cmd>BufferLineGoToBuffer -1<CR>", { silent = true })
  else
    for i = 1, 8 do
      keymap.set("n", "<M-" .. i .. ">", "<Cmd>tabnext " .. i .. "<CR>", { silent = true })
      keymap.set("t", "<M-" .. i .. ">", "<Cmd>tabnext " .. i .. "<CR>", { silent = true })
      keymap.set("i", "<M-" .. i .. ">", "<Cmd>tabnext " .. i .. "<CR>", { silent = true })
    end
    keymap.set("n", "<M-9>", "<Cmd>tablast<CR>", { silent = true })
    keymap.set("t", "<M-9>", "<Cmd>tablast<CR>", { silent = true })
    keymap.set("i", "<M-9>", "<Cmd>tablast<CR>", { silent = true })
  end

  if utils.is_plugin_registered("mini.files") then
    keymap.set("n", "<leader>e", "<Cmd>lua MiniFiles.open()<CR>")
  end
  if utils.is_plugin_registered("mini.pick") then
    keymap.set("n", "<leader>f", "<Cmd>Pick files<CR>")
  end
  if utils.is_plugin_registered("toggleterm.nvim") then
    keymap.set("n", "<leader>th", "<Cmd>ToggleTerm size=25 direction=horizontal<CR>")
    keymap.set("n", "<leader>tf", "<Cmd>ToggleTerm direction=float<CR>")
    keymap.set("n", "<leader>tv", "<Cmd>ToggleTerm size=80 direction=vertical<CR>")
    keymap.set("n", "<C-Enter>", "<Cmd>ToggleTerm<CR>")
    keymap.set("t", "<C-Enter>", "<Cmd>ToggleTerm<CR>")
  end

  if utils.is_plugin_registered("dropbar.nvim") then
    local dropbar_api = require("dropbar.api")
    keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
    keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
    keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
  end
end
