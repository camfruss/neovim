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
				-- rust-analyzer comes from rustup, so its version always matches
				-- the active toolchain's cargo (mason's copy drifts out of sync)
				"pyright",
				"ruff",
				"clangd",
				"taplo",
				"yaml-language-server",
				-- JetBrains Kotlin LSP; covers Jetpack Compose. Bundles its own
				-- JetBrains Runtime, so mason fetches a per-platform build.
				"kotlin-lsp",
				-- sourcekit-lsp is not a mason package: it ships with Xcode on macOS
				-- and with the Swift toolchain on Linux.

				-- formatters
				"stylua",
				"clang-format",
				"yamlfmt",
				"prettier",
				-- nix formatter: alejandra (mason's nixfmt package is linux_x64-only)
				"alejandra",
			},
			auto_update = false,
			run_on_start = true,
		},
	},
}
