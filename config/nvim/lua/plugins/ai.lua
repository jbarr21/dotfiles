return {
  {
      "olimorris/codecompanion.nvim",
      dependencies = {
          "nvim-lua/plenary.nvim",
          "nvim-treesitter/nvim-treesitter",
      },
      opts = {
  --     system_prompt = {
  --       enabled = true, -- Enable the tools system prompt?
  --       replace_main_system_prompt = false, -- Replace the main system prompt with the tools system prompt?
  --     },
          strategies = {
              chat = {
                  adapter = "claude_code",
              },
  --       chat = {
  --         adapter = "copilot",
  --       },
  --       inline = {
  --         adapter = "copilot",
  --       },
  --       agent = {
  --         adapter = "copilot",
  --       },
          },
      },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "codecompanion" }
  },
  {
    "ravitemer/mcphub.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = "npm install -g mcp-hub@latest",  -- Installs `mcp-hub` node binary globally
    config = function()
      require("mcphub").setup()
    end
  }
}
