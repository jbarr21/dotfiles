-- Use system clipboard by default
-- vim.o.clipboard = 'unnamedplus'
vim.o.clipboard = 'unnamedplus'

-- Use vertical diffs
vim.o.diffopt = 'vertical'

-- Quicker window movement
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Telescope additional mappings
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').command_history, { desc = '[S]earch [R]un commands' })

-- ToggleTerm bindings
vim.keymap.set('n', '<leader>t', ':ToggleTerm<CR>')

-- Setup mapping to call LazyGit
vim.keymap.set('n', '<leader>gg', ':LazyGit<CR>')

-- Neotree bindings
vim.keymap.set('n', '<leader>n', ':Neotree toggle<CR>')
-- nnoremap / :Neotree toggle current reveal_force_cwd<cr>
-- nnoremap | :Neotree reveal<cr>
-- nnoremap gd :Neotree float reveal_file=<cfile> reveal_force_cwd<cr>
-- nnoremap <leader>b :Neotree toggle show buffers right<cr>
-- nnoremap <leader>s :Neotree float git_status<cr>
