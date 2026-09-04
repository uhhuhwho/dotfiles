return {
  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      -- Setup clangd for C/C++ language
      lspconfig.clangd.setup({
        on_attach = function(client, bufnr)
          -- Define keymaps for LSP-related actions
          vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "LSP definition" })
          vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { buffer = bufnr, desc = "LSP references" })
        end,
      })
    end,
  },
}
