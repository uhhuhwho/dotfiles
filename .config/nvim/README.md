# ⚙️ Badreddine's Neovim Configuration

A modern, fast, and modular Neovim setup built using [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management, featuring LSP completion, syntax highlighting, a file explorer, buffers tabs, and terminal integration.

This setup is optimized for standard terminal Neovim and includes a lightweight fallback configuration when run inside VS Code.

---

## ✨ Features

- 🚀 **Lazy Loading** - Plugins load on-demand for blazing fast startup times
- 🎨 **Modern UI** - Tokyo Night theme with transparent background, statusline, and buffer tabs
- 📁 **File Explorer** - Integrated nvim-tree sidebar with intuitive navigation
- 🔍 **Fuzzy Finding** - Telescope for fast file and text searching with ripgrep
- 💡 **LSP Support** - Full language server protocol integration (configured for C/C++ via clangd)
- ✏️ **Smart Editing** - Treesitter syntax highlighting, autopairs, and snippets
- 🖥️ **Terminal Integration** - Floating terminal with toggleterm
- 🏷️ **TODO Highlighting** - Automatic detection of TODO, FIX, WARNING comments
- 📋 **System Clipboard** - Seamless integration with system clipboard
- 🎯 **VS Code Compatible** - Minimal fallback config when running inside VS Code

---

## 📋 Requirements

Before installing, ensure you have the following:

- **Neovim** >= 0.9.0 (recommended: latest stable version)
- **Git** - For cloning and plugin management
- **Node.js** - Required for some LSP servers and Treesitter
- **ripgrep** (`rg`) - For Telescope live grep functionality
- **A Nerd Font** - For proper icon rendering (recommended: [JetBrainsMono Nerd Font](https://www.nerdfonts.com/))
- **GCC or Clang** - For compiling Treesitter parsers
- **Optional**: Language servers for your languages (e.g., `clangd` for C/C++)

### Installation Commands (Arch Linux)

```bash
sudo pacman -S neovim git nodejs npm ripgrep gcc
# Install a Nerd Font (example: JetBrainsMono)
yay -S ttf-jetbrains-mono-nerd
```

---

## 🚀 Installation

### Fresh Install

1. **Backup existing configuration** (if any):
   ```bash
   mv ~/.config/nvim ~/.config/nvim.backup
   mv ~/.local/share/nvim ~/.local/share/nvim.backup
   mv ~/.local/state/nvim ~/.local/state/nvim.backup
   mv ~/.cache/nvim ~/.cache/nvim.backup
   ```

2. **Clone this repository**:
   ```bash
   git clone <your-repo-url> ~/.config/nvim
   ```

3. **Launch Neovim**:
   ```bash
   nvim
   ```
   
   On first launch, `lazy.nvim` will automatically:
   - Bootstrap itself
   - Install all configured plugins
   - Compile Treesitter parsers
   
   This may take a minute or two. You'll see a floating window with installation progress.

4. **Install LSP servers** (optional but recommended):
   ```bash
   # For C/C++ (clangd is pre-configured)
   sudo pacman -S clang
   
   # For other languages, install their respective language servers
   # Example: Python
   npm install -g pyright
   ```

5. **Restart Neovim** to ensure everything is loaded properly.

### Updating

To update plugins to their latest versions:

1. Open Neovim
2. Run `:Lazy sync`

To update the configuration itself:
```bash
cd ~/.config/nvim
git pull
```

---

## 📂 File Structure

The configuration follows a modular layout:

```text
~/.config/nvim/
├── init.lua           # Core entry point (handles environment detection)
├── README.md          # This documentation
├── lazy-lock.json     # Lockfile containing exact plugin versions
└── lua/
    ├── config/
    │   ├── options.lua # Vim settings (clipboard, tab size, line numbering)
    │   ├── keymaps.lua # Global keybindings and shortcuts
    │   ├── lazy.lua    # Bootstraps lazy.nvim and imports plugins
    │   └── vscode.lua  # Minimal configuration when running in VS Code
    └── plugins/
        ├── ui.lua      # Theme (tokyonight), statusline, bufferline
        ├── editor.lua  # Nvim-tree, telescope, toggleterm
        ├── coding.lua  # Treesitter, autocomplete, snippet engines
        └── lsp.lua     # LSP configurations (clangd setup)
```

---

## ⌨️ Keymaps & Shortcuts

The leader key is configured to `,` (comma).

### 🗂️ Navigation & Workspace Utilities
| Shortcut | Action | Description |
| :--- | :--- | :--- |
| `<leader>n` | Toggle File Explorer | Toggles the [nvim-tree](https://github.com/nvim-tree/nvim-tree.lua) sidebar |
| `<leader>t` | Toggle Floating Terminal | Launches a floating terminal via [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) |
| `<leader>ff` | Search Files | Fuzzy find files via [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) |
| `<leader>fg` | Live Grep | Search for text across your workspace using ripgrep |

### 📑 Buffer Management (Tabs)
| Shortcut | Action | Description |
| :--- | :--- | :--- |
| `<leader>bn` | Next Buffer | Jump to the next open buffer tab |
| `<leader>bp` | Previous Buffer | Jump to the previous open buffer tab |
| `<leader>bc` | Close Buffer | Safely delete/close the active buffer |

### 💻 Code Navigation (LSP active)
| Shortcut | Action | Description |
| :--- | :--- | :--- |
| `<leader>gd` | Go to Definition | Jump to definition of symbol under cursor |
| `<leader>gr` | Find References | Find all references of symbol under cursor |

### 🤖 Autocomplete & Snippets (Insert Mode)
| Shortcut | Action | Description |
| :--- | :--- | :--- |
| `<C-Space>` | Trigger Autocomplete | Manually show completion suggestions popup |
| `<Tab>` | Select Next | Cycles down the suggestions popup list |
| `<CR>` | Confirm Selection | Accept and insert selection, expanding any snippets |

---

## 🔌 Installed Plugins

*   **Theme & UI**:
    *   [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) - Transparent-enabled modern dark theme (`storm` style).
    *   [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Blazing fast bottom status line.
    *   [bufferline.nvim](https://github.com/akinsho/bufferline.nvim) - Buffer tabs at the top.
    *   [todo-comments.nvim](https://github.com/folke/todo-comments.nvim) - Scans and highlights tags like `TODO`, `FIX`, `WARNING`.
*   **Editor & Utilities**:
    *   [nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) - Sidebar file explorer.
    *   [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Highly extendable fuzzy finder.
    *   [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) - Easily persist and toggle terminals.
*   **Coding Assistance**:
    *   [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Fast incremental syntax highlighting.
    *   [nvim-autopairs](https://github.com/windwp/nvim-autopairs) - Automatically closes brackets and quotation marks.
    *   [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Engine for autocompletion popup.
    *   [LuaSnip](https://github.com/L3MON4D3/LuaSnip) - Lua snippet compiler.
*   **LSP Config**:
    *   [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - Standard configs for language server integrations (includes `clangd`).

---

## 🎯 Getting Started

### First Steps After Installation

1. **Open a project folder**:
   ```bash
   cd ~/your-project
   nvim
   ```

2. **Explore the file tree**:
   - Press `,n` to toggle the file explorer
   - Navigate with `j`/`k`, open files with `Enter`

3. **Search for files**:
   - Press `,ff` to fuzzy find files
   - Start typing to filter results
   - Use `Ctrl+n`/`Ctrl+p` to navigate, `Enter` to open

4. **Open a terminal**:
   - Press `,t` to toggle a floating terminal
   - Press `Esc` twice or `,t` again to close it

5. **Work with buffers**:
   - Open multiple files
   - Use `,bn` and `,bp` to cycle through open files
   - Use `,bc` to close the current buffer

### Using LSP Features

If you have an LSP server installed for your language (like `clangd` for C/C++):

1. **Go to definition**: Place cursor on a symbol and press `,gd`
2. **Find references**: Press `,gr` to see all references
3. **Hover documentation**: Press `K` (capital K) in normal mode
4. **Autocomplete**: Start typing in insert mode, press `Ctrl+Space` to trigger manually

---

## ⚙️ Customization

### Changing the Leader Key

The leader key is set to `,` (comma). To change it, edit [lua/config/options.lua](lua/config/options.lua):

```lua
vim.g.mapleader = " "  -- Change to space, or any other key
```

### Adding More LSP Servers

Edit [lua/plugins/lsp.lua](lua/plugins/lsp.lua) and add your language server:

```lua
require('lspconfig').pyright.setup{}  -- Example: Python
require('lspconfig').tsserver.setup{} -- Example: TypeScript
```

See [nvim-lspconfig server configurations](https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md) for available servers.

### Modifying Theme

The theme is configured in [lua/plugins/ui.lua](lua/plugins/ui.lua). To change the style or disable transparency:

```lua
require("tokyonight").setup({
  style = "night",  -- Change to "night", "moon", "day", or "storm"
  transparent = false,  -- Set to false to disable transparency
})
```

### Adding Keymaps

Add your custom keymaps in [lua/config/keymaps.lua](lua/config/keymaps.lua):

```lua
vim.keymap.set("n", "<leader>w", ":w<CR>", { silent = true, desc = "Save file" })
```

---

## 🐛 Troubleshooting

### Plugins Not Installing

1. Check your internet connection
2. Run `:Lazy sync` to retry
3. Check `:checkhealth lazy` for diagnostics

### LSP Not Working

1. Verify the language server is installed: `:LspInfo`
2. Check if the server is running: `:checkhealth lsp`
3. Ensure the file type is detected: `:set filetype?`

### Icons Not Showing

Install a [Nerd Font](https://www.nerdfonts.com/) and configure your terminal to use it.

### Clipboard Not Working

Ensure you have a clipboard provider installed:

```bash
# X11 (most Linux systems)
sudo pacman -S xclip

# Wayland
sudo pacman -S wl-clipboard
```

Run `:checkhealth` in Neovim to verify clipboard support.

### Treesitter Errors

If you see parser-related errors:

```vim
:TSInstall <language>  " Install a specific parser
:TSUpdate             " Update all installed parsers
```

---

## 📚 Useful Commands

| Command | Description |
| :--- | :--- |
| `:Lazy` | Open plugin manager UI |
| `:Lazy sync` | Update all plugins |
| `:Mason` | Open LSP/DAP/Linter installer (if configured) |
| `:LspInfo` | Show attached LSP servers |
| `:checkhealth` | Run health checks for Neovim environment |
| `:TSUpdate` | Update Treesitter parsers |
| `:TodoTelescope` | Search all TODO comments in project |

---

## 🤝 Contributing

Feel free to fork this configuration and customize it to your needs. If you find bugs or have suggestions, open an issue or pull request!

---

## 📝 License

This configuration is open source and available under the MIT License.

---

## 🙏 Acknowledgments

- [lazy.nvim](https://github.com/folke/lazy.nvim) - Amazing plugin manager by [@folke](https://github.com/folke)
- [Tokyo Night](https://github.com/folke/tokyonight.nvim) - Beautiful color scheme
- The entire Neovim community for their incredible work
