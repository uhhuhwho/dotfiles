----------------------------------------------------------------------------------------------------------------------------------
-- https://github.com/nvim-tree/nvim-tree.lua
----------------------------------------------------------------------------------------------------------------------------------
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true
----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------
-- Mapleader aka main key
vim.g.mapleader = ","  -- Set Leader key to , (space is problematic)
vim.opt.number = true  -- Enable line numbers
----------------------------------------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------------------------------------
-- Set tab size to 4 spaces
vim.opt.tabstop = 4       -- Number of visual spaces per tab
vim.opt.shiftwidth = 4    -- Number of spaces for each indentation level
vim.opt.expandtab = true  -- Use spaces instead of tabs
----------------------------------------------------------------------------------------------------------------------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
	{"folke/tokyonight.nvim"},          -- Tokyo night theme
    {"nvim-tree/nvim-tree.lua"},        -- A file explorer tree for neovim written in lua.
    {"nvim-tree/nvim-web-devicons"},    -- Install the web devicons plugin (For icons etc...)
    {"nvim-treesitter/nvim-treesitter"},  -- Treesitter
    {"nvim-telescope/telescope.nvim", dependencies = {"nvim-lua/plenary.nvim"}},
    {"akinsho/bufferline.nvim"},        -- A snazzy buffer line (with tabpage integration) for Neovim built using lua.
    {'akinsho/toggleterm.nvim', version = "*", config = true}, -- A neovim plugin to persist and toggle multiple terminals during an editing session.
    {'windwp/nvim-autopairs',event = "InsertEnter",config = true},
    {"nvim-lualine/lualine.nvim"},      -- A blazing fast and easy to configure neovim statusline plugin written in pure lua.
    {"neovim/nvim-lspconfig"},          -- Add lspconfig plugin
    {"hrsh7th/nvim-cmp"},               -- Completion plugin
    {"hrsh7th/cmp-nvim-lsp"}            -- LSP completion source for nvim-cmp
})

-- Theme setup
require("tokyonight").setup({
    style = "night",           -- Available styles: "night", "storm", "moon", "day"
    transparent = true,      -- Set to true for a transparent background
    terminal_colors = true,  -- Apply colors to the terminal
})
vim.cmd.colorscheme("tokyonight") -- This commands set the theme to the selected one.

-- Ensure nvim-tree is set up properly
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 25,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

-- Treesitter setup
require("nvim-treesitter.configs").setup {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed =
    {
        "glsl",
        "hlsl",
        "make",
        "ninja",
        "slang",
        "bash",
        "c",
        "cpp",
        "c_sharp",
        "html",
        "javascript",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "regex",
        "vim",
        "vimdoc",
        "xml",
    },
}

vim.opt.termguicolors = true -- https://github.com/akinsho/bufferline.nvim?tab=readme-ov-file#usage
-- bufferline.nvim
require("bufferline").setup({
  options = {
    numbers = "none",  -- Show numbers in tabs
    close_command = "bdelete %d",  -- Command to close the buffer (you can use :bdelete or :bd)
    right_mouse_command = "bdelete! %d",  -- Right-click command to close buffer
    left_mouse_command = "buffer %d",  -- Left-click command to switch buffer
    modified_icon = "*",  -- Icon for modified buffers
    show_buffer_icons = true,  -- Show file type icons
    show_tab_indicators = true,  -- Show tab indicators
    persist_buffer_sort = true,  -- Keep buffer order when switching tabs
    offsets = 
    {
        {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "center",
            separator = true  -- Adds a separator between sidebar and tabs
        }
    }
  }
})

-- Configuration for lualine.nvim
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 100,
      tabline = 100,
      winbar = 100,
    }
  },
    sections = {
        lualine_a = {'mode'},  -- Mode (normal, insert, etc.)
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},  -- File name
        lualine_x = {'filetype', 'encoding', 'location'},  -- Filetype, Encoding, Location (Line:Col)
        lualine_y = {'progress'},  -- Progress percentage
        lualine_z = {'locations'},
  },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {'filename'},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}

-- Setup clangd for C language
local lspconfig = require("lspconfig")

lspconfig.clangd.setup({
    on_attach = function(client, bufnr)
        -- Define keymaps for LSP-related actions (optional)
        vim.keymap.set("n", "<leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>gr", "<Cmd>lua vim.lsp.buf.references()<CR>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>gi", "<Cmd>lua vim.lsp.buf.implementation()<CR>", { buffer = bufnr })
        vim.keymap.set("n", "<leader>K", "<Cmd>lua vim.lsp.buf.hover()<CR>", { buffer = bufnr })
    end,
    flags = {
        debounce_text_changes = 150,
    },
})

-- Configure nvim-cmp to use the LSP for completion
local cmp = require'cmp'

cmp.setup({
    completion = {
        autocomplete = { cmp.TriggerEvent.TextChanged },  -- Auto trigger completion as you type
    },
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)  -- For snippet expansion (optional)
        end,
    },
    mapping = {
        ["<C-Space>"] = cmp.mapping.complete(),  -- Trigger completion manually
        ["<CR>"] = cmp.mapping.confirm({ select = true }),  -- Confirm selected completion
        ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),  -- Next completion
        ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),  -- Previous completion
    },
    sources = {
        { name = "nvim_lsp" },  -- LSP source for completion
    },
})

-- Toggle Terminal
require("toggleterm").setup({
  open_mapping = [[<leader>t]], -- Keybinding to toggle terminal
  hide_numbers = true,  -- Hide line numbers inside the terminal
  shade_terminals = true,  -- Dim inactive terminals
  start_in_insert = true,  -- Automatically enter insert mode
  insert_mappings = true,  -- Use insert mode mappings
  terminal_mappings = true,  -- Enable terminal mode mappings
  direction = "float",  -- Terminal opens in floating window (options: "horizontal", "vertical", "tab", "float")
  close_on_exit = true,  -- Automatically close terminal when process exits
  shell = vim.o.shell,  -- Use default shell
})

-- KEYMAPS

-- Keymaps for nvim-tree
vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>", { silent = true })

-- Keymap for searching files with Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- Keymaps for bufferline.nvim

-- Switch to the next buffer
vim.keymap.set('n', '<leader>bn', ':BufferLineCycleNext<CR>')
-- Switch to the previous buffer
vim.keymap.set('n', '<leader>bp', ':BufferLineCyclePrev<CR>')
-- Close the current buffer
vim.keymap.set('n', '<leader>bc', ':bdelete<CR>')
