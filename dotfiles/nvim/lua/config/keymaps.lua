-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Use MarkdownPreview command (open the markdown in a browser page)
vim.keymap.set("n", "<leader>mo", "<cmd>MarkdownPreview<cr>", { desc = "Markdown Preview" })
-- Use MarkdownPreview command to open in a browser and also zoom into buffer with the markdown file
vim.keymap.set("n", "<leader>mz", function()
  vim.cmd("MarkdownPreview")
  require("snacks").toggle.zoom():toggle()
end, { desc = "Markdown Preview and Zoom" })
