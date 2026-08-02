return {
	"saghen/blink.cmp",
	-- A release tag ships a prebuilt fuzzy-matcher binary, so no Rust build step.
	version = "1.*",
	event = "InsertEnter",
	opts = {
		-- <C-space> opens, <C-y> accepts, <C-n>/<C-p> cycle, <C-e> dismisses.
		-- <CR> stays a newline -- nothing is preselected, so it can't be stolen.
		keymap = { preset = "default" },
		sources = {
			-- buffer supplies identifiers already in the file, which covers local
			-- names rust-analyzer hasn't indexed (or won't, mid-edit).
			default = { "lsp", "buffer", "path", "snippets" },
		},
		completion = {
			-- Unlike the built-in, this triggers on any word character, not just
			-- the server's trigger characters.
			menu = { border = "rounded" },
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				window = { border = "rounded" },
			},
			list = { selection = { preselect = false, auto_insert = false } },
		},
		signature = { enabled = true, window = { border = "rounded" } },
		fuzzy = {
			implementation = "prefer_rust_with_warning",
			-- Default allows floor(#keyword / 4) typos, so a longer query starts
			-- matching things you didn't type. 0 means every item shown actually
			-- matches the characters typed, in order (fzf behaviour).
			max_typos = 0,
		},
	},
}
