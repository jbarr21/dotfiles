return {
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
    keys = {
      -- { "<leader>gD", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
      -- { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
    },
    opts = {
      view = {
        default = {
          winbar_info = true,
        },
      },
    },
  },
}
