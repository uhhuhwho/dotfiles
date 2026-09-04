-- Set Leader key to , (space is problematic)
vim.g.mapleader = ","

-- Force Neovim to always use system clipboard for yank/paste
vim.opt.clipboard = "unnamedplus"

-- Disable netrw at the very start (standard for nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Enable 24-bit colour
vim.opt.termguicolors = true

-- Enable line numbers
vim.opt.number = true

-- Set tab size to 4 spaces
vim.opt.tabstop = 4       -- Number of visual spaces per tab
vim.opt.shiftwidth = 4    -- Number of spaces for each indentation level
vim.opt.expandtab = true  -- Use spaces instead of tabs
