<h1 align="center">graphite.nvim</h1>

<p align="center">
  <strong>A Neovim plugin for the Graphite CLI — manage stacked Git workflows from within your editor.</strong><br>
  <em>Stack in place.</em>
</p>

<p align="center">
  <a href="https://github.com/dshan12/graphite.nvim"><img src="https://img.shields.io/badge/github-dshan12/graphite.nvim-8da0cb?style=flat&logo=github" alt="GitHub"/></a>
  <a href="https://github.com/dshan12/graphite.nvim/blob/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-green?style=flat" alt="License"/></a>
  <a href="https://neovim.io"><img src="https://img.shields.io/badge/Neovim-0.7+-blueviolet?style=flat&logo=neovim" alt="Neovim"/></a>
  <a href="https://github.com/dshan12/graphite.nvim"><img src="https://img.shields.io/github/stars/dshan12/graphite.nvim?style=flat&logo=github" alt="Stars"/></a>
  <a href="https://lunarmodules.github.io/lua"><img src="https://img.shields.io/badge/Lua-02027B?style=flat&logo=lua" alt="Lua"/></a>
</p>

---

## Why graphite.nvim?

If you use the Graphite CLI (`gt`) for stacked pull requests, you've probably found yourself constantly tabbing to a terminal to run `gt branch list`, `gt log`, `gt submit`, or any of the 40+ CLI commands. Every context switch breaks your flow.

graphite.nvim brings everything into Neovim:

- **An interactive dashboard** with four panes — Branches, Status, Commits, Diff — so you have full situational awareness at a glance
- **40+ `:Graphite*` commands** that mirror the `gt` CLI exactly — no new syntax to learn
- **Zero external dependencies** — pure Lua, Neovim 0.7+, and the `gt` binary

Think of it as lazygit's interaction model applied to Graphite's stacked workflow.

## Comparison to Alternatives

| Feature | graphite.nvim | kroucher/graphite.nvim | zhongdai/graphite-nvim | lazygit.nvim | neogit |
|---------|:---:|:---:|:---:|:---:|:---:|
| Graphite CLI integration | ✅ Full | ⚠️ Partial (10) | ⚠️ Partial (3) | ❌ | ❌ |
| Interactive dashboard | ✅ 4-pane TUI | ❌ | ❌ | ✅ (lazygit) | ✅ (Magit-style) |
| 40+ commands | ✅ 58 | ❌ ~10 | ❌ 3 | N/A | N/A |
| Stack submit/restack/split | ✅ | ❌ | ❌ | ❌ | ❌ |
| Pure Lua (no external deps) | ✅ | ✅ | ✅ | ❌ (lazygit binary) | ✅ |
| MIT License | ✅ | ❌ | ✅ | ✅ | ✅ |
| Active development | ✅ 2026 | ❌ Abandoned | ❌ Unmaintained | ✅ | ✅ |

graphite.nvim is complementary to lazygit.nvim and neogit — use them for general Git operations, and graphite.nvim for stacked PR workflows.

## Features

- **Interactive Dashboard** — A lazygit-style TUI dashboard with four panes: Branches, Commits, Status, and Diff
- **Full CLI Coverage** — Wraps all major `gt` commands: auth, branch, commit, stack, downstack, upstack, repo, log, and more
- **40+ User Commands** — Every `:Graphite*` command is a direct mapping to the `gt` CLI
- **Dashboard Keymaps** — Single-key shortcuts for create, checkout, restack, submit, and more
- **Automatic Detection** — Warns if the `gt` CLI is not installed
- **~830 lines of pure Lua** — small, auditable, no bloat

## Requirements

- **Neovim >= 0.7** (Lua API)
- **Graphite CLI** (`gt`) — Install from [graphite.dev](https://graphite.dev)

## Quick Start

```lua
-- 1. Install with lazy.nvim
{
  "dshan12/graphite.nvim",
  opts = {},
}

-- 2. Restart Neovim
-- 3. Run :GraphiteDashboard or press <leader>gd
```

That's it. The dashboard opens in a floating window with four panes showing your branches, working tree status, recent commits, and current diff.

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "dshan12/graphite.nvim",
  opts = {
    executable = "gt", -- optional: path to gt binary
  },
}
```

### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "dshan12/graphite.nvim",
  config = function()
    require("graphite").setup({
      executable = "gt",
    })
  end,
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'dshan12/graphite.nvim'

lua << EOF
require("graphite").setup({
  executable = "gt",
})
EOF
```

### [paq-nvim](https://github.com/savq/paq-nvim)

```lua
"dshan12/graphite.nvim";
```

Then call `require("graphite").setup()` in your config.

## Configuration

`graphite.nvim` works out of the box with zero configuration.

### Setup Options

```lua
require("graphite").setup({
  -- The `gt` executable path or binary name.
  -- Default: "gt"
  executable = "gt",
})
```

If `gt` is not found in your `PATH`, a warning is shown on startup.

### Customizing Keymaps

All keymaps are set via Neovim's built-in API, so you can override any of them after calling `setup()`.

#### Dashboard Keymaps

The dashboard registers these keys inside the floating window. To override:

```lua
require("graphite").setup()

-- Override dashboard keymaps after setup
vim.api.nvim_create_autocmd("FileType", {
  pattern = "graphite-dashboard",
  callback = function()
    -- Close with Escape instead of q
    vim.api.nvim_buf_set_keymap(0, "n", "<Esc>", "", {
      noremap = true,
      silent = true,
      callback = function()
        require("graphite.ui.dashboard").close_dashboard()
      end,
    })
  end,
})
```

> **Note:** The dashboard does not set a filetype yet, so to reliably override you can monkey-patch after require:

```lua
require("graphite").setup()

-- Override dashboard refresh key
local dashboard = require("graphite.ui.dashboard")
local orig_refresh = dashboard.refresh_dashboard
dashboard.refresh_dashboard = function()
  -- custom refresh logic
  orig_refresh()
end
```

#### Global Leader Keymap

By default `<leader>gd` opens the dashboard. Override it:

```lua
require("graphite").setup({
  executable = "gt",
})

-- Override the leader mapping
vim.keymap.set("n", "<leader>gt", ":GraphiteDashboard<CR>", { noremap = true, silent = true })
```

If you want to disable the default `<leader>gd` mapping entirely, you can remove it after setup:

```lua
require("graphite").setup()
pcall(vim.api.nvim_del_keymap, "n", "<leader>gd")
```

### Dashboard Key Reference

These are the default keymaps set inside each dashboard pane:

#### Global (any pane)

| Key | Action |
|-----|--------|
| `q` | Close dashboard |
| `r` | Refresh all panes |
| `Tab` | Cycle to next pane |
| `S-Tab` | Cycle to previous pane |

#### Branches Pane

| Key | Action |
|-----|--------|
| `c` | `:GraphiteBranchCreate` |
| `C` | `:GraphiteBranchCheckout` |
| `d` | `:GraphiteBranchDelete` |
| `s` | `:GraphiteBranchSubmit` |
| `r` | `:GraphiteBranchRestack` |
| `j` | Move cursor down, show branch info |
| `k` | Move cursor up, show branch info |

#### Commits Pane

| Key | Action |
|-----|--------|
| `c` | `:GraphiteCommitCreate` |
| `a` | `:GraphiteCommitAmend` |

#### Diff Pane

| Key | Action |
|-----|--------|
| `a` | Apply diff |
| `r` | Reset diff |

## Usage

### Dashboard

The dashboard is a floating-window TUI with four panes:

| Pane | Location | Content |
|------|----------|---------|
| Branches | Top-left | List of all branches |
| Status | Top-right | Working tree status |
| Commits | Bottom-left | Recent commit history |
| Diff | Bottom-right | Current diff |

Open with `:GraphiteDashboard` or press `<leader>gd`.

#### Dashboard Keymaps

| Key | Action |
|-----|--------|
| `q` | Close dashboard |
| `r` | Refresh all panes |
| `Tab` | Next pane |
| `S-Tab` | Previous pane |

### Commands

`graphite.nvim` registers **40+ user commands** under the `:Graphite` prefix. They mirror the `gt` CLI.

#### Dashboard

| Command | Description |
|---------|-------------|
| `:GraphiteDashboard` | Open the interactive dashboard |

#### Auth

| Command | Description |
|---------|-------------|
| `:GraphiteAuth <args>` | Authenticate with Graphite |

#### Branch

| Command | Description |
|---------|-------------|
| `:GraphiteBranchCreate <name>` | Create a new branch |
| `:GraphiteBranchCheckout <name>` | Checkout a branch |
| `:GraphiteBranchUp` | Move up the stack |
| `:GraphiteBranchDown` | Move down the stack |
| `:GraphiteBranchTop` | Go to the top of the stack |
| `:GraphiteBranchBottom` | Go to the bottom of the stack |
| `:GraphiteBranchInfo` | Show branch info |
| `:GraphiteBranchDelete <name>` | Delete a branch |
| `:GraphiteBranchRename <name>` | Rename a branch |
| `:GraphiteBranchRestack` | Restack the branch |
| `:GraphiteBranchSplit <args>` | Split a branch |
| `:GraphiteBranchSquash <args>` | Squash a branch |
| `:GraphiteBranchSubmit` | Submit the branch for review |
| `:GraphiteBranchTrack <branch>` | Track a branch |
| `:GraphiteBranchUntrack <branch>` | Untrack a branch |
| `:GraphiteBranchUnbranch` | Convert branch back to a regular commit |

#### Commit

| Command | Description |
|---------|-------------|
| `:GraphiteCommitCreate <msg>` | Create a commit |
| `:GraphiteCommitAmend` | Amend the last commit |

#### Stack

| Command | Description |
|---------|-------------|
| `:GraphiteStackRestack` | Restack the entire stack |
| `:GraphiteStackSubmit` | Submit the entire stack |
| `:GraphiteStackTest` | Run tests on the stack |

#### Downstack

| Command | Description |
|---------|-------------|
| `:GraphiteDownstackEdit <args>` | Edit downstack |
| `:GraphiteDownstackGet <args>` | Get downstack info |
| `:GraphiteDownstackRestack` | Restack downstack |
| `:GraphiteDownstackSubmit` | Submit downstack |
| `:GraphiteDownstackTest` | Test downstack |
| `:GraphiteDownstackTrack <args>` | Track downstack |

#### Upstack

| Command | Description |
|---------|-------------|
| `:GraphiteUpstackOnto <branch>` | Move upstack onto a branch |
| `:GraphiteUpstackRestack` | Restack upstack |
| `:GraphiteUpstackSubmit` | Submit upstack |
| `:GraphiteUpstackTest` | Test upstack |

#### Repo

| Command | Description |
|---------|-------------|
| `:GraphiteRepoInit` | Initialize Graphite in the repo |
| `:GraphiteRepoName [name]` | Get or set the repo name |
| `:GraphiteRepoOwner [owner]` | Get or set the repo owner |
| `:GraphiteRepoPRTemplates <args>` | Manage PR templates |
| `:GraphiteRepoRemote <args>` | Manage remote config |
| `:GraphiteRepoSync` | Sync with remote |

#### Log

| Command | Description |
|---------|-------------|
| `:GraphiteLog <args>` | Show log |
| `:GraphiteLogShort <args>` | Show short log |
| `:GraphiteLogLong <args>` | Show long log |

#### User

| Command | Description |
|---------|-------------|
| `:GraphiteUserBranchDate [format]` | Get or set branch date format |
| `:GraphiteUserBranchPrefix [prefix]` | Get or set branch prefix |
| `:GraphiteUserBranchReplacement <args>` | Manage branch replacements |
| `:GraphiteUserEditor [editor]` | Get or set the editor |
| `:GraphiteUserPager [pager]` | Get or set the pager |
| `:GraphiteUserRestackDate [format]` | Get or set restack date format |
| `:GraphiteUserSubmitBody <args>` | Manage submit body template |
| `:GraphiteUserTips` | Show tips |

#### Diff

| Command | Description |
|---------|-------------|
| `:GraphiteDiffApply <args>` | Apply a diff |
| `:GraphiteDiffReset <args>` | Reset a diff |

#### Other

| Command | Description |
|---------|-------------|
| `:GraphiteChangelog` | Show the changelog |
| `:GraphiteCompletion` | Show shell completion setup |
| `:GraphiteContinue` | Continue an interrupted operation |
| `:GraphiteDash` | Show the dashboard (alias) |
| `:GraphiteDocs` | Open Graphite documentation |
| `:GraphiteFeedback <args>` | Send feedback |
| `:GraphiteDebugContext` | Show debug context |
| `:GraphiteFish` | Fish shell integration |

## Architecture

```
lua/
├── graphite/
│   ├── init.lua                  # Entry point, registers all commands
│   ├── utils.lua                 # CLI execution helpers
│   ├── commands/
│   │   ├── auth.lua              # Authentication
│   │   ├── branch.lua            # Branch operations
│   │   ├── changelog.lua         # Changelog display
│   │   ├── commit.lua            # Commit operations
│   │   ├── completion.lua        # Shell completion
│   │   ├── continue.lua          # Continue operations
│   │   ├── dash.lua              # Dashboard alias
│   │   ├── diff.lua              # Diff operations
│   │   ├── docs.lua              # Documentation
│   │   ├── downstack.lua         # Downstack operations
│   │   ├── feedback.lua          # Feedback/debug
│   │   ├── fish.lua              # Fish shell
│   │   ├── log.lua               # Log display
│   │   ├── repo.lua              # Repository management
│   │   ├── stack.lua             # Stack operations
│   │   ├── upstack.lua           # Upstack operations
│   │   └── user.lua              # User configuration
│   └── ui/
│       └── dashboard.lua         # Interactive TUI dashboard
└── plugin/
    └── graphite.lua              # Plugin loader (auto-requires graphite)
```

## Development

### Running Locally

Clone the repo and add it to your Neovim config:

```lua
-- lazy.nvim
{
  dir = "~/path/to/graphite.nvim",
  opts = {},
}
```

### Testing

```bash
luac -p lua/**/*.lua
```

Make sure all Lua files parse without errors.

## FAQ

**Q: What is Graphite?**  
A: [Graphite](https://graphite.dev) is a CLI tool for stacked Git workflows — making code review faster by organizing commits into a stack of dependent branches.

**Q: Do I need the `gt` CLI?**  
A: Yes. This plugin is a client wrapper around the `gt` binary. Install it from [graphite.dev](https://graphite.dev/docs/install).

**Q: Can I customize the `gt` path?**  
A: Yes. Pass `executable = "/path/to/gt"` to `setup()`.

## Contributing

Contributions are welcome! Please open an issue or submit a PR on [GitHub](https://github.com/dshan12/graphite.nvim).

## License

[MIT](LICENSE) &copy; 2024 Darshan Sathish Kumar
