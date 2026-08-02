return {
	"rebelot/kanagawa.nvim",
	priority = 1000,
	config = function()
		require("kanagawa").setup({
			-- Kanagawa recesses floats onto a darker background (sumiInk0
			-- #16161d) than the editor (sumiInk3 #1f1f28), which reads as a black
			-- rectangle sitting behind the rounded border. Drop the float
			-- backgrounds so they inherit Normal and only the border line shows.
			overrides = function(colors)
				local theme = colors.theme
				return {
					NormalFloat = { bg = "none" },
					FloatBorder = { bg = "none" },
					FloatTitle = { bg = "none" },
					-- Kanagawa's diff change (#252535) and text (#49443C) sit within
					-- a few percent of the normal background (#1f1f28), so changed
					-- lines are nearly invisible. Reuse the theme's own visual and
					-- search blues: still kanagawa, but clearly separated from the
					-- green adds and red deletes.
					DiffChange = { bg = theme.ui.bg_visual },
					DiffText = { bg = theme.ui.bg_search, bold = true },
					-- Kanagawa links the completion menu to Pmenu (blue #223249)
					-- but its documentation window to NormalFloat, so the two halves
					-- of the same popup don't match. Put the menu on the float
					-- styling too; the blue then only marks the selected row.
					BlinkCmpMenu = { link = "NormalFloat" },
					BlinkCmpMenuBorder = { link = "FloatBorder" },
				}
			end,
		})
		vim.cmd.colorscheme("kanagawa")
	end,
}
