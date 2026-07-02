return {
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			ui = { border = "rounded" },
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		event = { "BufReadPre", "BufNewFile" },
		opts = {
			ensure_installed = {
				-- lsps
				"lua-language-server",
				"rust-analyzer",
				"pyright",
				"ruff",
				"clangd",
				"taplo",
				"yaml-language-server",

				-- formatters
				"stylua",
				"clang-format",
				"yamlfmt",
				"prettier",
			},
			auto_update = false,
			run_on_start = true,
		},
	},
}
