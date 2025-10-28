[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Enable zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Enable zsh-syntax-highlighting (must be sourced last)
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

. $(brew --prefix asdf)/libexec/asdf.sh

# Initialize Starship prompt
eval "$(starship init zsh)"
