return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      automatic_installation = {
        exclude = { "copilot" },
      },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      -- LazyVim's ai.sidekick extra adds copilot for NES, but we disable NES.
      -- Prevent the copilot language server from being configured.
      if opts.servers and opts.servers.copilot then
        opts.servers.copilot = nil
      end
    end,
  },
}
