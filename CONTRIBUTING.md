# Contributing to graphite.nvim

Thanks for considering contributing! This project aims to be the go-to Neovim plugin for the Graphite CLI, and every contribution helps.

## Getting Started

1. Fork the repository
2. Clone your fork: `git clone git@github.com:YOUR_USERNAME/graphite.nvim.git`
3. Add the plugin to your Neovim config using a local path:

```lua
{
  dir = "~/path/to/graphite.nvim",
  opts = {},
}
```

## Development Guidelines

### Code Style
- Follow existing patterns in the codebase
- Use pure Lua — no external dependencies beyond Neovim's built-in API
- Keep functions small and focused
- Prefer descriptive names over comments

### Lua Style
- Use `local M = {}` pattern for modules
- Return `M` at end of each module
- Use `vim.api` functions over legacy `vim.fn` where possible
- Two-space indentation

### Commit Messages
Write clear, conventional commit messages:

```
feat: add support for gt branch submit --force
fix: handle empty response from gt log
docs: update README with new commands
refactor: extract common CLI execution logic
```

### Testing
Run syntax checks before submitting:

```bash
luac -p lua/**/*.lua
```

All files must parse without errors.

## Pull Request Process

1. Create a feature branch from `main`
2. Make your changes
3. Run syntax checks
4. Open a PR with a clear description of what and why
5. Keep PRs focused — one feature or fix per PR

## Feature Requests

Open an issue describing:
- What you want to add
- Why it's useful
- How it should work (optional)

## Bug Reports

Open an issue with:
- Neovim version (`nvim --version`)
- `gt` CLI version (`gt --version`)
- Steps to reproduce
- Expected vs actual behavior

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
