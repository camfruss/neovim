return {
	"rebelot/kanagawa.nvim",
	priority = 1000,
	config = function()
		require("kanagawa").setup({
			-- opts
		})
		vim.cmd.colorscheme("kanagawa")
	end,
}
