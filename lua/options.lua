-- options.lua
local opt = vim.opt

opt.number = true
vim.cmd [[silent! colorscheme gruvbox]]

opt.textwidth = 80
vim.cmd [[let &colorcolumn=join(range(81,999),",")]]

opt.list = true
opt.listchars = "tab:▸ ,eol:¬,nbsp:␣,extends:›,precedes:‹"

opt.ignorecase = true
opt.smartcase = true

vim.cmd("filetype plugin indent on")
vim.wo.foldmethod = "syntax"
--opt.foldexpr="nvim_treesitter#foldexpr()"
vim.cmd("autocmd BufReadPost,FileReadPost * normal zR")
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.backspace = "indent,eol,start"
opt.spell = true
opt.spelllang = "en_us"
opt.wildmenu = true
opt.hidden = true
opt.wildignore = "*.exe,*.dll,*.pdb,*.so"
opt.completeopt = "menu,menuone,preview,noselect,noinsert"
