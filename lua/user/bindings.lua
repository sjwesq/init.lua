-- lua/user/bindings.lua
-- Saving these lines for a rainy day:
-- local is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1
-- local is_mac = vim.fn.has("macunix")

local api = vim.api
local keymap = vim.keymap

-- Commands -------------------------------------------------------------------

api.nvim_create_user_command("Vimrc", "edit " .. vim.fn.stdpath("config"), {})

-- For recording
if vim.g.neovide then
  api.nvim_create_user_command("Trans", function()
    vim.g.neovide_opacity = 0.8
    vim.o.guifont = "Iosevka:h29"
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

keymap.set("c", "<C-E>", "<End>") -- I think blink breaks this?

-- Plugin Bindings ------------------------------------------------------------
-- Firefox-style tab switching
if package.loaded["bufferline"] then
  keymap.set("n", "<M-1>", "<Cmd>BufferLineGoToBuffer 1<CR>", { silent = true })
  keymap.set("n", "<M-2>", "<Cmd>BufferLineGoToBuffer 2<CR>", { silent = true })
  keymap.set("n", "<M-3>", "<Cmd>BufferLineGoToBuffer 3<CR>", { silent = true })
  keymap.set("n", "<M-4>", "<Cmd>BufferLineGoToBuffer 4<CR>", { silent = true })
  keymap.set("n", "<M-5>", "<Cmd>BufferLineGoToBuffer 5<CR>", { silent = true })
  keymap.set("n", "<M-6>", "<Cmd>BufferLineGoToBuffer 6<CR>", { silent = true })
  keymap.set("n", "<M-7>", "<Cmd>BufferLineGoToBuffer 7<CR>", { silent = true })
  keymap.set("n", "<M-8>", "<Cmd>BufferLineGoToBuffer 8<CR>", { silent = true })
  keymap.set("n", "<M-9>", "<Cmd>BufferLineGoToBuffer -1<CR>", { silent = true })
end

if package.loaded["mini.files"] then
  keymap.set("n", "<leader>e", "<Cmd>lua MiniFiles.open()<CR>")
end

if package.loaded["mini.pick"] then
  keymap.set("n", "<leader>f", "<Cmd>Pick files<CR>")
end

if package.loaded["toggleterm"] then
  keymap.set("n", "<leader>th", "<Cmd>ToggleTerm size=25 direction=horizontal<CR>")
  keymap.set("n", "<leader>tf", "<Cmd>ToggleTerm direction=float<CR>")
  keymap.set("n", "<leader>tv", "<Cmd>ToggleTerm size=80 direction=vertical<CR>")
  keymap.set("n", "<C-Enter>", "<Cmd>ToggleTerm<CR>")
  keymap.set("t", "<C-Enter>", "<Cmd>ToggleTerm<CR>")
end
