-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set('n', '<leader>ac', '<cmd>CodeCompanionChat Toggle<cr>', { desc = 'Toggle (Code Companion)' })
vim.keymap.set('n', '<leader>cp', '<cmd>CodeCompanion<cr>', { desc = 'Prompt (Code Companion)' })
