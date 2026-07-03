return {
	{
		"nvim-mini/mini.diff",
		version = "*",
		config = function()
			require("mini.diff").setup({
				view = {
					style = "sign",
					signs = {
						add = "+",
						change = "±",
						delete = "-",
					},
				},
			})
		end,
	},
	{
		"nvim-mini/mini.surround",
		version = "*",
		config = function()
			require("mini.surround").setup({})
		end,
	},
}
