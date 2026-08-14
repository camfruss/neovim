require("config.options")
require("config.keymaps")
require("config.lsp")
-- After config.lsp so a repo's local file can extend a server already declared
-- there; before lazy.setup so plugin specs see anything it sets.
require("config.local")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
