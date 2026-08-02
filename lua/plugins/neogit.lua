return {
	"NeogitOrg/neogit",
	lazy = false,
	dependencies = {
		"sindrets/diffview.nvim",
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		kind = "floating",
		-- Floats always draw above normal windows in the same tabpage, so with a
		-- floating status buffer any view that opens as a split lands *behind* it
		-- and looks like nothing happened. Neogit's defaults put two such views in
		-- the way: commit_view ("vsplit", used by <CR> on a stash or commit) and
		-- popup ("split"). Give the diff its own tab and float the popups.
		commit_view = { kind = "tab" },
		popup = { kind = "floating" },
		disable_context_highlighting = true,
		mappings = {
			status = {
				["<esc>"] = "Close",
			},
		},
	},
	keys = {
		{ "<leader>gg", "<cmd>Neogit<cr>", desc = "Show Neogit UI" },
	},
}
