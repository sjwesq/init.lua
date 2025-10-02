local opt = vim.opt

opt.number = false

opt.textwidth = 80
opt.colorcolumn = "80"
opt.termguicolors = true

opt.list = false
opt.listchars = "tab:▸ ,eol:¬,nbsp:␣,extends:›,precedes:‹"

opt.ignorecase = true
opt.smartcase = true

opt.wrap = true
opt.linebreak = true

vim.cmd("filetype plugin indent on")
opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.backspace = "indent,eol,start"
opt.spell = true
opt.spelllang = "en_us"
opt.spelloptions = "camel"
opt.wildmenu = true
opt.hidden = false
opt.confirm = true
opt.virtualedit = "block"
opt.wildignore = "*.exe,*.dll,*.pdb,*.so"
opt.completeopt = "menu,menuone,preview,noselect,noinsert"
opt.splitbelow = true
opt.updatetime = 2000
opt.shada = "!,'29,f1,<50,s10,h"

opt.undofile = true

vim.diagnostic.config({
  virtual_text = {
    prefix = vim.g.enable_nerd_fonts and " " or "[!]",
    spacing = 2,
  },
})

if vim.g.neovide then
  vim.o.guifont = "Ligconsolata Nerd Font:h13:#e-subpixelantialias"
  vim.g.neovide_input_macos_option_key_is_meta = "both"
end
