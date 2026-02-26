# dotfiles

Personal macOS dotfiles for setting up a new machine from scratch.

## What's Included

- **Homebrew** — package manager with formulas, casks, and Mac App Store apps
- **Zsh** — shell config with Starship prompt and Nerd Font
- **Neovim** — configured with lazy.nvim, Telescope, Treesitter, Harpoon, LSP (mason + lspconfig), and autocompletion (nvim-cmp)
- **Alacritty** — terminal emulator with theme support
- **asdf** — version manager for Node.js, Python, and AWS CLI
- **macOS defaults** — Finder, Dock, trackpad, and keyboard preferences
- **Rosetta 2** — automatic install on Apple Silicon

## Prerequisites

- macOS (Apple Silicon or Intel)
- Signed in to the Mac App Store (for MAS installs)
- The [macos-setup](https://github.com/bermudezcristian/macos-setup) repo for base system configuration

## Usage

```bash
git clone https://github.com/bermudezcristian/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup.sh
```

The setup script is idempotent — safe to run multiple times. It will skip anything already installed.

## What Gets Configured

| Step | Description |
|------|-------------|
| Homebrew | Install/update Homebrew, formulas, and casks |
| Starship | Install Starship prompt + Nerd Font |
| MAS Apps | 1Password, iMovie, Xcode |
| asdf | Version manager with Node.js, Python, AWS CLI plugins |
| macOS Defaults | Finder, Dock, trackpad, keyboard settings |
| Neovim | Symlinked config with lazy.nvim plugin management |
| Alacritty | Symlinked config with theme repository |
| Dotfile Symlinks | `.zshrc`, `.config/nvim`, `.config/alacritty`, `.config/starship` |
| Rosetta 2 | Installed on Apple Silicon Macs |
