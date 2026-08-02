Leader is `<Space>`. Keys written bare (e.g. `sa`, `]h`, `K`) take no leader.

Telescope
--
ff - find files (includes tracked dotfiles)
gf - git files (tracked + staged + untracked)
pf - previously opened files
fb - open buffers
lg - live grep (re-runs ripgrep as you type)
fw - grep word under cursor / visual selection
fp - previous search history
fh - help tags
sr - registers & macros (`<C-e>` edits the highlighted one, `<CR>` pastes)

LSP
--
ds - document symbols (this file)
fd - find definition
fr - find references
fi - find implementations
e  - line diagnostics in a float (press twice to enter it, then `q`)

Neovim ships these without a leader:
K   - hover documentation
grn - rename
gra - code action
grr - references (quickfix)
gri - implementation
grt - type definition
gO  - document symbols
]d / [d - next / previous diagnostic

Completion (blink.cmp)
--
Triggers while typing. Sources: LSP, buffer words, paths, snippets --
buffer words only appear when the LSP returns nothing.

C-n / C-p - next / previous item
C-y       - accept
C-e       - dismiss
C-space   - open menu; again toggles documentation
C-b / C-f - scroll the documentation window
C-k       - toggle signature help
Tab / S-Tab - jump between snippet placeholders

`<CR>` is always a newline; nothing is preselected.

Diff / review (diffview)
--
dt - toggle diff of the working tree
da - diff from start: merge-base..HEAD (committed branch work)
dw - diff whole: merge-base..working tree (includes uncommitted)
dn - next commit on this branch, one at a time (oldest first)
dp - previous commit
dh - this branch's commit list
df - history of the current file

Inside a diffview tab (no leader):
Tab / S-Tab - next / previous file
gf          - open the real file in the previous tab
g<C-x>      - cycle layout (side-by-side / stacked / unified)
g?          - help panel
<leader>b   - toggle the file panel

Git
--
gg  - Neogit UI
gbo - open the PR (or commit) that last touched this line
]h / [h - next / previous hunk (centered)
hs - stage hunk
hr - reset hunk
hp - preview hunk
hu - undo stage hunk
hb - blame line (popup)
hB - blame whole file
ht - toggle inline blame
hD - toggle diff base between the index and the branch merge-base

In Neogit, `<CR>` on a stash opens Neogit's own unified view; press `d` then
`d` for the side-by-side diffview instead.

Navigation
--
These all recenter the cursor afterwards (no leader):
C-o / C-i - jump back / forward
g; / g,   - older / newer change
C-d / C-u - half page down / up
{ / }     - previous / next paragraph

Surround (mini.surround, no leader)
--
sa - add surrounding
sd - delete surrounding
sr - replace surrounding
sf / sF - find right / left surrounding
sh - highlight surrounding

Suffix `n` targets the next match and `l` the previous, e.g. `srn`, `sdl`.

Files & misc
--
-   - open parent directory in Oil (no leader)
g.  - toggle hidden files, inside Oil (no leader)
cf  - apply formatter (conform)
tc  - close tab
swd - set cwd to the current file's folder, or the folder Oil is viewing
