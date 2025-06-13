# Sophie's Neovim Init Scripts

**Neovim 0.11 or higher is HIGHLY recommended, as it is required by some
plugins.**

Just as it says on the tin -- my personal init scripts for Neovim. Designed to
be as portable as possible and sanely organized. It also should be safe to
disable any problematic plugins by commenting them out in `plugins.lua` -- the
scripts are designed and tested so that is safe to do so. If a plugin is
disabled, any plugin-relevant autocmds or keybindings simply won't activate.

## Known Dependencies

I've confirmed the following:

- **Neovim version >= 0.11**
- `git`
- `gcc` (or `clang`)
- `ripgrep`
- `pip`
- `python-pynvim`
- `tree-sitter` (install through `npm`)
- **Optionally:** A font patched using [Nerd Fonts](https://www.nerdfonts.com)
    - Compatibility without Nerd Fonts can be significantly improved adjusting
    `enable_nerd_fonts` to `false` in `plugins.lua`
    - Even still, certain UI elements will be broken without them (removing
    icons for noice.nvim is just nightmarish)

It should be easy enough to figure out how to get everything working using
`:checkhealth`, anyway. This is also how you can determine what to disable if
you're facing version incompatibilities, as well.

You'll need to manually install any language servers you want to make use of
using `:Mason` as well, of course.
