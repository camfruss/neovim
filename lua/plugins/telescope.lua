return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			defaults = {
				file_ignore_patterns = { "%.git/" },
			},
			pickers = {
				find_files = {
					-- Show tracked dotfiles (still respects .gitignore, so
					-- ignored files stay hidden).
					hidden = true,
				},
				git_files = {
					-- `ls-files --cached` already covers tracked + staged (the
					-- index holds both); --others adds untracked, minus anything
					-- .gitignore'd.
					show_untracked = true,
				},
			},
		},
		keys = {
			-- Files
			{
				"<leader>ff",
				"<cmd>Telescope find_files<cr>",
				desc = "Find files",
			},
			{
				"<leader>gf",
				"<cmd>Telescope git_files<cr>",
				desc = "Git files (tracked + staged + untracked)",
			},
			{
				"<leader>pf",
				"<cmd>Telescope oldfiles<cr>",
				desc = "Previously opened files",
			},
			{
				"<leader>fb",
				"<cmd>Telescope buffers<cr>",
				desc = "Buffers",
			},

			-- Search
			{
				"<leader>lg",
				"<cmd>Telescope live_grep<cr>",
				desc = "Live grep",
			},
			{
				"<leader>fw",
				"<cmd>Telescope grep_string<cr>",
				-- grep_string greps <cword> in normal mode and the selection in
				-- visual mode, so one mapping covers both.
				mode = { "n", "v" },
				desc = "Find word under cursor",
			},
			{
				"<leader>fp",
				"<cmd>Telescope search_history<cr>",
				desc = "List Search History (p for previous)",
			},
			{
				"<leader>fh",
				"<cmd>Telescope help_tags<cr>",
				desc = "Help Tags",
			},
			{
				"<leader>sr",
				-- Macros live in the a-z registers, so this lists them too.
				-- <CR> pastes the register, <C-e> edits it in place.
				"<cmd>Telescope registers<cr>",
				desc = "Show registers & macros",
			},

			-- Code / LSP
			{
				"<leader>ds",
				"<cmd>Telescope lsp_document_symbols<cr>",
				desc = "Code symbols (this file)",
			},
			{
				"<leader>fr",
				"<cmd>Telescope lsp_references<cr>",
				desc = "Find references",
			},
			{
				"<leader>fd",
				"<cmd>Telescope lsp_definitions<cr>",
				desc = "Find definition",
			},
			{
				"<leader>fi",
				"<cmd>Telescope lsp_implementations<cr>",
				desc = "LSP Implementations",
			},
		},
	},
}
