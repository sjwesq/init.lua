-- bindings.lua
-- Saving these lines for a rainy day:
-- local is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1
-- local is_mac = vim.fn.has("macunix")

local api = vim.api
local keymap = vim.keymap

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
keymap.set('n', '<space>e', vim.diagnostic.open_float)
keymap.set('n', '[d', vim.diagnostic.goto_prev)
keymap.set('n', ']d', vim.diagnostic.goto_next)
keymap.set('n', '<space>q', vim.diagnostic.setloclist)

api.nvim_create_user_command("Vimrc", "edit " .. vim.fn.stdpath("config"), {})

-- Remove search highlight
keymap.set('n', '<leader>h', "<Cmd>nohl<CR>")

-- Set current directory to file
keymap.set('n', '<leader>d', "<Cmd>cd %:p:h<CR><Cmd>pwd<CR>")

-- Ctrl-S to save {
keymap.set('i', '<C-s>', "<Esc><Cmd>w<CR>a")
keymap.set('n', '<C-s>', "<Cmd>w<CR>")

-- Quick window navigation
keymap.set('n', '<C-h>', "<Cmd>wincmd h<CR>", {silent = true})
keymap.set('n', '<C-j>', "<Cmd>wincmd j<CR>", {silent = true})
keymap.set('n', '<C-k>', "<Cmd>wincmd k<CR>", {silent = true})
keymap.set('n', '<C-l>', "<Cmd>wincmd l<CR>", {silent = true})

--------------------------------------------------------------------------------
--- Plugin Bindings
--------------------------------------------------------------------------------
--- Firefox-style tab switching
if package.loaded["bufferline"] then
  keymap.set('n', '<M-1>', "<Cmd>BufferLineGoToBuffer 1<CR>", {silent = true})
  keymap.set('n', '<M-2>', "<Cmd>BufferLineGoToBuffer 2<CR>", {silent = true})
  keymap.set('n', '<M-3>', "<Cmd>BufferLineGoToBuffer 3<CR>", {silent = true})
  keymap.set('n', '<M-4>', "<Cmd>BufferLineGoToBuffer 4<CR>", {silent = true})
  keymap.set('n', '<M-5>', "<Cmd>BufferLineGoToBuffer 5<CR>", {silent = true})
  keymap.set('n', '<M-6>', "<Cmd>BufferLineGoToBuffer 6<CR>", {silent = true})
  keymap.set('n', '<M-7>', "<Cmd>BufferLineGoToBuffer 7<CR>", {silent = true})
  keymap.set('n', '<M-8>', "<Cmd>BufferLineGoToBuffer 8<CR>", {silent = true})
  keymap.set('n', '<M-9>', "<Cmd>BufferLineGoToBuffer -1<CR>", {silent = true})
end

if package.loaded["mini.files"] then
  keymap.set('n', '<leader>fm',"<Cmd>lua MiniFiles.open()<CR>")
end

if package.loaded["telescope"] then
  local builtin = require('telescope.builtin')
  keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
  keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
  keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
  keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
end

if package.loaded["toggleterm"] then
  keymap.set('n', '<leader>th', "<Cmd>ToggleTerm size=30 direction=horizontal<CR>")
  keymap.set('n', '<leader>tf', "<Cmd>ToggleTerm direction=float<CR>")
  keymap.set('n', '<leader>tv', "<Cmd>ToggleTerm size=80 direction=vertical<CR>")
  keymap.set('n', '<C-Enter>', "<Cmd>ToggleTerm<CR>")
  keymap.set('t', '<C-Enter>', "<Cmd>ToggleTerm<CR>")
end
