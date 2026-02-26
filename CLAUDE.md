# CLAUDE.md — Project Instructions for Claude Code

## Repository Purpose
Personal macOS dotfiles. Manages Homebrew packages, macOS defaults, shell config (zsh + Starship), Neovim, Alacritty, and dev tooling via a single idempotent `setup.sh` script.

## Structure
```
dotfiles/
    .config/
        alacritty/          # Alacritty terminal config
        nvim/
            init.lua        # Entry point — requires bermudezcristian/
            lua/bermudezcristian/
                init.lua    # Editor settings (options, remaps)
                lazy.lua    # Plugin specs (lazy.nvim)
        starship/           # Starship prompt config
    .zshrc                  # Zsh shell configuration
    setup.sh                # Main setup script
```

## Conventions
- **Indentation**: 4 spaces everywhere (shell scripts, Lua). No tabs.
- **setup.sh functions**: Each function is idempotent — safe to run repeatedly. Guard installs with `command -v` or `brew list` checks.
- **Neovim plugins**: Use lazy.nvim spec format. Each plugin is a table in the `require("lazy").setup({...})` call. Use tabs for Lua indentation within the Neovim config (matches lazy.nvim defaults).
- **Symlinks**: `link_dotfiles()` in setup.sh handles symlinking from `~/dotfiles/` to `~/.config/` and `~/.zshrc`.
- **macOS only**: The setup script exits early on non-Darwin systems.
