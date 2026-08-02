vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.wrap = false

-- Keep vertical mouse scrolling, but disable horizontal: a count of 0 turns a
-- direction off. Trackpad sideways gestures no longer slide the view, so long
-- lines are simply cut off at the window edge.
opt.mousescroll = { "ver:3", "hor:0" }

opt.ignorecase = true
opt.smartcase = true

-- Diff readability. histogram produces tighter, more intuitive hunks than the
-- default myers; indent-heuristic stops a hunk landing on the wrong brace or
-- blank line; linematch pairs up changed lines *within* a hunk so the
-- word-level highlight marks what actually changed (0.11 defaults to 40).
-- Set rather than append: 0.11 already ships linematch:40, and appending would
-- leave both values in the list.
opt.diffopt = {
	"internal",
	"filler",
	"closeoff",
	"algorithm:histogram",
	"indent-heuristic",
	"linematch:60",
}

-- Hatch the filler region where one side has no lines, rather than '-' dashes,
-- so added/removed blocks are obvious at a glance.
opt.fillchars:append({ diff = "╱" })

-- Completion menu: always show it even for a single match, never preselect an
-- entry (so <CR> stays a newline), and show docs in a floating window.
opt.completeopt = { "menuone", "noselect", "popup" }

-- Default border for every floating window that doesn't set its own
-- (diagnostics, hover, signature help). Nvim 0.11+.
opt.winborder = "rounded"
