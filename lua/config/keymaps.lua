-- Open the GitHub PR (or commit) that last touched the current line.
local function open_pr_for_line()
	local file = vim.api.nvim_buf_get_name(0)
	local line = vim.fn.line(".")

	local function fail(msg, level)
		vim.schedule(function()
			vim.notify(msg, level or vim.log.levels.ERROR)
		end)
	end

	vim.system(
		{ "git", "blame", "-L", line .. "," .. line, "--porcelain", "--", file },
		{ text = true },
		function(blame)
			if blame.code ~= 0 then
				return fail("git blame failed: " .. (blame.stderr or ""))
			end
			local sha = (blame.stdout or ""):match("^(%x+)")
			if not sha or sha:match("^0+$") then
				return fail("Line is not committed yet", vim.log.levels.WARN)
			end

			vim.system(
				{ "gh", "repo", "view", "--json", "nameWithOwner", "-q", ".nameWithOwner" },
				{ text = true },
				function(repo_res)
					local repo = vim.trim(repo_res.stdout or "")
					if repo_res.code ~= 0 or repo == "" then
						return fail("Not a GitHub repo (gh: " .. vim.trim(repo_res.stderr or "") .. ")")
					end

					vim.system(
						{ "gh", "api", "repos/" .. repo .. "/commits/" .. sha .. "/pulls", "-q", ".[0].html_url" },
						{ text = true },
						function(pr_res)
							local url = vim.trim(pr_res.stdout or "")
							if url == "" or url == "null" then
								url = "https://github.com/" .. repo .. "/commit/" .. sha
							end
							vim.schedule(function()
								vim.notify("Opening " .. url)
								vim.ui.open(url)
							end)
						end
					)
				end
			)
		end
	)
end

vim.keymap.set("n", "<leader>gbo", open_pr_for_line, { desc = "Git blame: open PR/commit for line" })

-- Set the working directory to the folder of the current file, or, when in an
-- oil buffer, the folder currently being viewed.
vim.keymap.set("n", "<leader>swd", function()
	local dir
	if vim.bo.filetype == "oil" then
		local ok, oil = pcall(require, "oil")
		dir = ok and oil.get_current_dir()
	elseif vim.bo.buftype == "" then
		dir = vim.fn.expand("%:p:h")
	end
	if not dir or dir == "" then
		vim.notify("No directory for current buffer", vim.log.levels.WARN)
		return
	end
	vim.cmd.cd(vim.fn.fnameescape(dir))
	vim.notify("cwd → " .. dir)
end, { desc = "Set cwd to current file's/oil folder" })

vim.keymap.set("n", "<leader>tc", "<cmd>tabclose<cr>", { desc = "Close tab" })

-- Show the diagnostics for the current line. Press twice to enter the float,
-- then scroll or yank from it.
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics (float)" })

-- Keep the cursor centered after jumps and half-page scrolls.
for lhs, desc in pairs({
	["<C-o>"] = "Jump back (centered)",
	["<C-i>"] = "Jump forward (centered)",
	["g;"] = "Older change (centered)",
	["g,"] = "Newer change (centered)",
	["<C-d>"] = "Half page down (centered)",
	["<C-u>"] = "Half page up (centered)",
	["{"] = "Previous paragraph (centered)",
	["}"] = "Next paragraph (centered)",
}) do
	vim.keymap.set("n", lhs, lhs .. "zz", { desc = desc })
end
