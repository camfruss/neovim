return {
	"stevearc/oil.nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			default_file_explorer = true,
			keymaps = {
				["g."] = "actions.toggle_hidden",
			},
		})

		vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory in Oil" })
	end,
}
