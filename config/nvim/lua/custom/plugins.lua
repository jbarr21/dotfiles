return function(use)
  use { "folke/which-key.nvim", config = function()
    require("which-key").setup({})
  end }

  use { "akinsho/toggleterm.nvim", tag = '*', config = function()
    require("toggleterm").setup()
  end }

  function _G.set_terminal_keymaps()
    local opts = {buffer = 0}
    vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
    -- vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
    vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
    vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
    vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
    vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  end

  -- if you only want these mappings for toggle term use term://*toggleterm#* instead
  vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

  use 'kdheepak/lazygit.nvim'

  use 'moll/vim-bbye'

  use { "epwalsh/obsidian.nvim", config = function()
    require("obsidian").setup({
      dir = "~/Documents/notes",
      completion = {
        nvim_cmp = true, -- if using nvim-cmp, otherwise set to false
      }
    })
  end }

end
