vim.lsp.set_log_level("OFF")

vim.diagnostic.config({
	-- Sort by severity so the worst problem on a line wins the sign column and
	-- shows first in the float.
	severity_sort = true,
	underline = true,
	virtual_text = {
		prefix = "●",
		spacing = 2,
		source = "if_many", -- only name the server when several are attached
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "󰅚",
			[vim.diagnostic.severity.WARN] = "󰀪",
			[vim.diagnostic.severity.INFO] = "󰋽",
			[vim.diagnostic.severity.HINT] = "󰌶",
		},
	},
	float = {
		border = "rounded",
		source = "if_many",
		header = "",
		prefix = "● ",
		focusable = true, -- press <C-w>d twice to enter the float and scroll/yank
	},
})

vim.lsp.enable({
    "lua_ls",
    "rust_analyzer",
    "pyright",
    "ruff",
    "clangd",
    "taplo",
    "yamlls",
})
