-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.o.foldlevel = 999 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 999
vim.o.foldenable = true
vim.o.foldcolumn = "0"

-- Neovide config
vim.g.neovide_cursor_trail_length = 0
vim.g.neovide_cursor_animation_length = 0.1
vim.g.neovide_transparency = 0.8
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_cursor_unfocused_outline_width = 0.125
vim.g.neovide_cursor_distance_length_adjust = 1
vim.g.neovide_cursor_vfx_mode = "ripple"
vim.g.neovide_refresh_rate = 60
vim.g.neovide_fullscreen = false

-- windblend
vim.o.winblend = 30
vim.o.pumblend = 30

vim.opt.autowrite = true -- enable auto write
vim.o.timeoutlen = 200
vim.opt.guifont = "FiraCode Nerd Font:h9"
vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.scrolloff = 4 -- Lines of context
vim.opt.wrap = true -- Line wrap
