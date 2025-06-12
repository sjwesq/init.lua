# Sophie's Neovim Init Scripts

Just as it says on the tin -- my personal init scripts for Neovim. Designed to
be as portable as possible and sanely organized. I'll have to test the
dependencies in a bit but the main ones that come to mind are `gcc` (for mason)
and `python3-neovim` (generic dependency.) It should be easy enough to figure
out how to get everything working using `:checkhealth`, anyway.

It also should be safe to disable any problematic plugins by commenting them out in
`plugins.lua` -- the scripts are designed and tested so that is safe to do so. If
a plugin is disabled, any plugin-relevant autocmds or keybindings simply won't
activate.
