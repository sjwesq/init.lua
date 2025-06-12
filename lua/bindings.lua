-- bindings.lua
-- Saving this line for a rainy day:
-- local is_windows = vim.fn.has("win64") == 1 or vim.fn.has("win32") == 1
local api = vim.api
local keymap = vim.keymap
local cmd = vim.cmd

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
keymap.set('n', '<space>e', vim.diagnostic.open_float)
keymap.set('n', '[d', vim.diagnostic.goto_prev)
keymap.set('n', ']d', vim.diagnostic.goto_next)
keymap.set('n', '<space>q', vim.diagnostic.setloclist)

api.nvim_create_user_command("Vimrc", "edit " .. vim.fn.stdpath("config"), {})

keymap.set('n', '<leader>h', "<Cmd>nohl<CR>")
keymap.set('n', '<leader>d', "<Cmd>cd %:p:h<CR><Cmd>pwd<CR>")

-- Ctrl-S to save {
cmd("imap <c-s> <Esc><Cmd>w<CR>a")
cmd("nmap <c-s> <Cmd>w<CR>")

-- Quick window navigation
cmd("nmap <silent> <c-k> <Cmd>wincmd k<CR>")
cmd("nmap <silent> <c-j> <Cmd>wincmd j<CR>")
cmd("nmap <silent> <c-h> <Cmd>wincmd h<CR>")
cmd("nmap <silent> <c-l> <Cmd>wincmd l<CR>")

-- Leave terminals easily

--------------------------------------------------------------------------------
--- Plugin Bindings
--------------------------------------------------------------------------------
--- Browser-style tab switching
if package.loaded["bufferline"] then
  cmd("nmap <silent> <M-1> <Cmd>BufferLineGoToBuffer 1<CR>")
  cmd("nmap <silent> <M-2> <Cmd>BufferLineGoToBuffer 2<CR>")
  cmd("nmap <silent> <M-3> <Cmd>BufferLineGoToBuffer 3<CR>")
  cmd("nmap <silent> <M-4> <Cmd>BufferLineGoToBuffer 4<CR>")
  cmd("nmap <silent> <M-5> <Cmd>BufferLineGoToBuffer 5<CR>")
  cmd("nmap <silent> <M-6> <Cmd>BufferLineGoToBuffer 6<CR>")
  cmd("nmap <silent> <M-7> <Cmd>BufferLineGoToBuffer 7<CR>")
  cmd("nmap <silent> <M-8> <Cmd>BufferLineGoToBuffer 8<CR>")
end

if package.loaded["mini.files"] then
  keymap.set('n', '<leader>fm',"<Cmd>lua MiniFiles.open()<CR>")
end

if package.loaded["Telescope"] then
  local builtin = require('telescope.builtin')
  keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
  keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
  keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
  keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
end

if package.loaded["toggleterm"] then
  keymap.set('n', '<leader>t', "<Cmd>ToggleTerm size=30 direction=horizontal<CR>")
  keymap.set('n', '<leader>f', "<Cmd>ToggleTerm direction=float<CR>")
  keymap.set('n', '<leader>v', "<Cmd>ToggleTerm size=80 direction=vertical<CR>")
  keymap.set('n', '<C-BS>', "<Cmd>ToggleTerm<CR>")
  keymap.set('t', '<C-BS>', "<Cmd>ToggleTerm<CR>")
end
