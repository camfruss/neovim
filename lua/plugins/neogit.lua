return {
	"NeogitOrg/neogit",
	lazy = false,
	dependencies = {
		"sindrets/diffview.nvim",
		"nvim-telescope/telescope.nvim",
	},
	opts = {
		kind = "floating",
		-- On a large repo (tens of thousands of tracked files, many submodules) a
		-- single refresh spawns ~50 git processes for several seconds of work,
		-- most of it repeated `status --porcelain=2`. With the filewatcher on,
		-- anything writing into the tree -- a build, above all -- triggers that
		-- over and over, which is what makes the UI feel wedged. Refresh manually
		-- with <C-r> instead.
		filewatcher = { enabled = false },
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
