# Neovim config

Leader is <kbd>Space</kbd>. Keys shown without a `<leader>` prefix are bare
mappings — `sa`, `]h`, `K` and friends are typed as written.

## Telescope

| Key          | Action                                          |
| ------------ | ----------------------------------------------- |
| `<leader>ff` | Find files (includes tracked dotfiles)          |
| `<leader>gf` | Git files — tracked + staged + untracked        |
| `<leader>pf` | Previously opened files                         |
| `<leader>fb` | Open buffers                                    |
| `<leader>lg` | Live grep — re-runs ripgrep as you type         |
| `<leader>fw` | Grep word under cursor, or the visual selection |
| `<leader>fp` | Previous search history                         |
| `<leader>fh` | Help tags                                       |
| `<leader>sr` | Registers & macros                              |

Inside the registers picker, `<C-e>` edits the highlighted register and `<CR>`
pastes it.

## LSP

| Key          | Action                       |
| ------------ | ---------------------------- |
| `<leader>ds` | Document symbols (this file) |
| `<leader>fd` | Find definition              |
| `<leader>fr` | Find references              |
| `<leader>fi` | Find implementations         |
| `<leader>e`  | Line diagnostics in a float  |

Press `<leader>e` twice to enter the float, then `q` to close it.

Neovim provides these automatically when a language server attaches, so the
config doesn't redefine them:

| Key         | Action                     |
| ----------- | -------------------------- |
| `K`         | Hover documentation        |
| `grn`       | Rename                     |
| `gra`       | Code action                |
| `grr`       | References (quickfix)      |
| `gri`       | Implementation             |
| `grt`       | Type definition            |
| `gO`        | Document symbols           |
| `]d` / `[d` | Next / previous diagnostic |

## Completion

Triggers while typing, via [blink.cmp](https://github.com/saghen/blink.cmp).
Sources are LSP, buffer words, paths and snippets — buffer words appear only
when the language server returns nothing.

| Key                 | Action                                         |
| ------------------- | ---------------------------------------------- |
| `<C-n>` / `<C-p>`   | Next / previous item                           |
| `<C-y>`             | Accept                                         |
| `<C-e>`             | Dismiss                                        |
| `<C-space>`         | Open menu; press again to toggle documentation |
| `<C-b>` / `<C-f>`   | Scroll the documentation window                |
| `<C-k>`             | Toggle signature help                          |
| `<Tab>` / `<S-Tab>` | Jump between snippet placeholders              |

`<CR>` is always a newline — nothing is preselected, so it can't be stolen by
the menu.

## Diff & review

Reviewing a branch before opening a PR, via
[diffview](https://github.com/sindrets/diffview.nvim).

| Key          | Action                                                        |
| ------------ | ------------------------------------------------------------- |
| `<leader>dt` | Toggle diff of the working tree                               |
| `<leader>da` | Diff from start — `merge-base..HEAD`, committed branch work   |
| `<leader>dw` | Diff whole — `merge-base..working tree`, includes uncommitted |
| `<leader>dn` | Next commit on this branch, one at a time (oldest first)      |
| `<leader>dp` | Previous commit                                               |
| `<leader>dh` | This branch's commit list                                     |
| `<leader>df` | History of the current file                                   |

Inside a diffview tab:

| Key                 | Action                                        |
| ------------------- | --------------------------------------------- |
| `<Tab>` / `<S-Tab>` | Next / previous file                          |
| `gf`                | Open the real file in the previous tab        |
| `g<C-x>`            | Cycle layout — side-by-side, stacked, unified |
| `g?`                | Help panel                                    |
| `<leader>b`         | Toggle the file panel                         |

## Git

| Key           | Action                                                       |
| ------------- | ------------------------------------------------------------ |
| `<leader>gg`  | Neogit UI                                                    |
| `<leader>gbo` | Open the PR (or commit) that last touched this line          |
| `]h` / `[h`   | Next / previous hunk (centered)                              |
| `<leader>hs`  | Stage hunk                                                   |
| `<leader>hr`  | Reset hunk                                                   |
| `<leader>hp`  | Preview hunk                                                 |
| `<leader>hu`  | Undo stage hunk                                              |
| `<leader>hb`  | Blame line (popup)                                           |
| `<leader>hB`  | Blame whole file                                             |
| `<leader>ht`  | Toggle inline blame                                          |
| `<leader>hD`  | Toggle diff base between the index and the branch merge-base |

> [!NOTE]
> In Neogit, `<CR>` on a stash opens Neogit's own unified view. For the
> side-by-side diffview, press `d` then `d` instead.

## Navigation

All of these recenter the cursor afterwards.

| Key               | Action                    |
| ----------------- | ------------------------- |
| `<C-o>` / `<C-i>` | Jump back / forward       |
| `g;` / `g,`       | Older / newer change      |
| `<C-d>` / `<C-u>` | Half page down / up       |
| `{` / `}`         | Previous / next paragraph |

## Surround

Via [mini.surround](https://github.com/nvim-mini/mini.surround).

| Key         | Action                        |
| ----------- | ----------------------------- |
| `sa`        | Add surrounding               |
| `sd`        | Delete surrounding            |
| `sr`        | Replace surrounding           |
| `sf` / `sF` | Find right / left surrounding |
| `sh`        | Highlight surrounding         |

Add an `n` suffix to target the next match, or `l` for the previous one — e.g.
`srn`, `sdl`.

## Files & misc

| Key           | Action                                                             |
| ------------- | ------------------------------------------------------------------ |
| `-`           | Open parent directory in Oil                                       |
| `g.`          | Toggle hidden files (inside Oil)                                   |
| `<leader>cf`  | Apply formatter (conform)                                          |
| `<leader>tc`  | Close tab                                                          |
| `<leader>swd` | Set cwd to the current file's folder, or the folder Oil is viewing |
