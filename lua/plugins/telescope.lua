return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{
				"<leader>fp",
				"<cmd>Telescope search_history<cr>",
				desc = "List Search History (p for previous)",
			},
			{
				"<leader>fo",
				"<cmd>Telescope oldfiles<cr>",
				desc = "List old files",
			},
			{
				"<leader>ff",
				"<cmd>Telescope find_files<cr>",
				desc = "Find Files",
			},
			{
				"<leader>fg",
				"<cmd>Telescope live_grep<cr>",
				desc = "Live Grep",
			},
			{
				"<leader>fb",
				"<cmd>Telescope buffers<cr>",
				desc = "Buffers",
			},
			{
				"<leader>fh",
				"<cmd>Telescope help_tags<cr>",
				desc = "Help Tags",
			},
		},
	},
}
