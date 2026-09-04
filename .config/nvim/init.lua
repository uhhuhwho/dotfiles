-- Dynamic Neovim Configuration Entrypoint
-- Detects if running inside VS Code and loads the appropriate config module.

if vim.g.vscode then
  require("config.vscode")
else
  require("config.options")
  require("config.lazy")
  require("config.keymaps")
end
