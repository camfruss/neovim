-- WARN, not OFF: OFF discards a server's stderr and exit code, so a crash
-- leaves no trace. WARN keeps errors and exits without the request/response
-- traffic that previously grew lsp.log to 380 MB. Read it with :LspLog.
vim.lsp.set_log_level("WARN")

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

-- Centre the cursor line after an LSP jump lands.
--
-- Selecting from a telescope picker already centres -- telescope composes
-- actions.center into its select actions. The gap is the case that never opens a
-- picker: with exactly one result, telescope's LSP builtins jump straight through
-- vim.lsp.util.show_document and return (telescope/builtin/__lsp.lua). A
-- definition is almost always unique, so <leader>fd took that path every time and
-- landed wherever the jump left the view -- often with the definition on the last
-- line of the window. Wrapping the select actions cannot reach it; nor can zz on
-- the keymap, since `<cmd>Telescope ...<cr>` returns while the request is still in
-- flight.
--
-- Patching show_document rather than the pickers also covers plain vim.lsp.buf
-- jumps, which land the same way and are worth centring for the same reason.
local show_document = vim.lsp.util.show_document
vim.lsp.util.show_document = function(location, encoding, opts)
	local jumped = show_document(location, encoding, opts)
	-- focus = false means the caller is populating a preview or a background
	-- window; the cursor the user is looking at did not move, and centring here
	-- would scroll an unrelated window.
	if jumped and not (opts and opts.focus == false) then
		vim.cmd("normal! zz")
	end
	return jumped
end

local servers = {
	"lua_ls",
	"rust_analyzer",
	"pyright",
	"ruff",
	"clangd",
	"taplo",
	"yamlls",
}

-- This config is shared between macOS and Linux, and these two servers aren't
-- present on every machine: sourcekit-lsp comes from Xcode or a Swift toolchain,
-- kotlin-lsp from mason. Enable them only where they exist, so a missing binary
-- doesn't produce a client that fails on every Swift or Kotlin buffer.
--
-- Both probes avoid mason's PATH entry, which isn't set up yet at this point:
-- sourcekit-lsp is a plain PATH lookup, kotlin-lsp a direct file check.
if vim.fn.executable("sourcekit-lsp") == 1 then
	table.insert(servers, "sourcekit")
end

if vim.uv.fs_stat(vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", "intellij-server")) then
	table.insert(servers, "kotlin_lsp")
end

vim.lsp.enable(servers)
