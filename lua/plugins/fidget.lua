return {
	"j-hui/fidget.nvim",
	event = "LspAttach",
	opts = {
		progress = {
			display = {
				done_ttl = 2, -- keep a finished task visible briefly
			},
		},
		notification = {
			window = {
				winblend = 0, -- opaque, readable over any background
			},
		},
	},
}
