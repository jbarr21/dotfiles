-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("x", "<leader>gb", function()
  local first = math.min(vim.fn.line("v"), vim.fn.line("."))
  local last = math.max(vim.fn.line("v"), vim.fn.line("."))

  local file = vim.api.nvim_buf_get_name(0)
  local root = LazyVim.root.git()
  local relative = vim.fs.relpath(root, file)

  if not relative then
    vim.notify("Current file is outside the Git repository", vim.log.levels.ERROR)
    return
  end

  Snacks.picker.git_log({
    title = ("Git Log Lines %d–%d"):format(first, last),
    cwd = root,
    cmd_args = {
      "-L",
      ("%d,%d:%s"):format(first, last, relative),
    },
  })
end, { desc = "Git Blame Selection" })
