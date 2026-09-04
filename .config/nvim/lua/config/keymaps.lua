-- Set mapleader (just in case options.lua is loaded in a different order)
vim.g.mapleader = ","

-- Keymaps for nvim-tree
vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>", { silent = true })

-- Keymaps for Telescope (using functions to support lazy loading)
vim.keymap.set('n', '<leader>ff', function() require('telescope.builtin').find_files() end, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', function() require('telescope.builtin').live_grep() end, { desc = 'Telescope live grep' })

-- Keymaps for bufferline.nvim
vim.keymap.set('n', '<leader>bn', ':BufferLineCycleNext<CR>', { silent = true })
vim.keymap.set('n', '<leader>bp', ':BufferLineCyclePrev<CR>', { silent = true })
vim.keymap.set('n', '<leader>bc', ':bdelete<CR>', { silent = true })
