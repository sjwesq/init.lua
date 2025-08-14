-- lua/user/options.lua
local opt = vim.opt

opt.number = true

opt.textwidth = 80
opt.colorcolumn = "80"

opt.list = false
opt.listchars = "tab:▸ ,eol:¬,nbsp:␣,extends:›,precedes:‹"

opt.ignorecase = true
opt.smartcase = true

vim.cmd("filetype plugin indent on")
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.backspace = "indent,eol,start"
opt.spell = true
opt.spelllang = "en_us"
opt.wildmenu = true
opt.hidden = true
opt.confirm = true
opt.virtualedit = "block"
opt.wildignore = "*.exe,*.dll,*.pdb,*.so"
opt.completeopt = "menu,menuone,preview,noselect,noinsert"

opt.undofile = true

vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 2,
  },
})

if vim.g.neovide then
  vim.o.guifont = "Ligconsolata Nerd Font:h12:#e-subpixelantialias"
  vim.g.neovide_input_macos_option_key_is_meta = "both"
end
