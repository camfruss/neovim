return {
	{
		"nvim-mini/mini.diff",
		version = "*",
		config = function()
			require("mini.diff").setup({})
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
