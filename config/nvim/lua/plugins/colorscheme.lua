return {
  {
		"catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    -- Until LazyVim/LazyVim/issues/6355 resolved:
		opts = function(_, opts)
			local module = require("catppuccin.groups.integrations.bufferline")
			if module then
				module.get = module.get_theme
			end
			return opts
		end,
	},

  -- Configure LazyVim to load theme
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
