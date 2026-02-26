[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Enable zsh-autosuggestions
[ -f "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Enable zsh-syntax-highlighting (must be sourced last)
[ -f "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Enable asdf version manager
[ -f "$(brew --prefix asdf)/libexec/asdf.sh" ] && . "$(brew --prefix asdf)/libexec/asdf.sh"

# Alias
alias vim='nvim'

# Enable zsh completion system
autoload -Uz compinit
compinit

# Initialize Starship prompt
eval "$(starship init zsh)"
