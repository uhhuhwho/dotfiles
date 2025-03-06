-- Check if running inside VS Code
if not vim.g.vscode then
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
        {"akinsho/bufferline.nvim"},        -- A snazzy buffer line (with tabpage integration)
        {'akinsho/toggleterm.nvim', version = "*", config = true}, -- Toggle terminal
        {'windwp/nvim-autopairs',event = "InsertEnter",config = true},
        {"nvim-lualine/lualine.nvim"},      -- A blazing fast statusline plugin
        {"neovim/nvim-lspconfig"},          -- LSP config
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

    -- bufferline.nvim
    require("bufferline").setup({
      options = {
        numbers = "none",  
        close_command = "bdelete %d",  
        right_mouse_command = "bdelete! %d",
        left_mouse_command = "buffer %d",
        modified_icon = "*",
        show_buffer_icons = true,
        show_tab_indicators = true,
        persist_buffer_sort = true,
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "center",
                separator = true  
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
      },
        sections = {
            lualine_a = {'mode'},  
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = {'filename'},  
            lualine_x = {'filetype', 'encoding', 'location'},  
            lualine_y = {'progress'},  
            lualine_z = {'locations'},
      },
    }

    -- Setup clangd for C language
    local lspconfig = require("lspconfig")

    lspconfig.clangd.setup({
        on_attach = function(client, bufnr)
            -- Define keymaps for LSP-related actions (optional)
            vim.keymap.set("n", "<leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", { buffer = bufnr })
            vim.keymap.set("n", "<leader>gr", "<Cmd>lua vim.lsp.buf.references()<CR>", { buffer = bufnr })
        end,
    })

    -- Configure nvim-cmp to use the LSP for completion
    local cmp = require'cmp'

    cmp.setup({
        completion = {
            autocomplete = { cmp.TriggerEvent.TextChanged },  
        },
        snippet = {
            expand = function(args)
                vim.fn["vsnip#anonymous"](args.body)
            end,
        },
        mapping = {
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        },
        sources = {
            { name = "nvim_lsp" },  
        },
    })

    -- Toggle Terminal
    require("toggleterm").setup({
      open_mapping = [[<leader>t]], 
      hide_numbers = true,  
      shade_terminals = true,  
      start_in_insert = true,  
      insert_mappings = true,  
      terminal_mappings = true,  
      direction = "float",  
      close_on_exit = true,  
      shell = vim.o.shell,  
    })

    -- KEYMAPS

    -- Keymaps for nvim-tree
    vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>", { silent = true })

    -- Keymap for searching files with Telescope
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })

    -- Keymaps for bufferline.nvim
    vim.keymap.set('n', '<leader>bn', ':BufferLineCycleNext<CR>')
    vim.keymap.set('n', '<leader>bp', ':BufferLineCyclePrev<CR>')
    vim.keymap.set('n', '<leader>bc', ':bdelete<CR>')
else
    -- VS Code specific settings (if needed)
    vim.g.mapleader = ","  -- Set Leader key to , (space is problematic)
    vim.opt.number = true
    vim.opt.tabstop = 4       -- Number of visual spaces per tab
    vim.opt.shiftwidth = 4    -- Number of spaces for each indentation level
    vim.opt.expandtab = true  -- Use spaces instead of tabs
end