# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '

setopt PROMPT_SUBST
PROMPT='%F{green}%n@%m %f%F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '

# Enable auto update
zstyle ':omz:update' mode auto

plugins=(git)

. ~/.aliases.sh

source $ZSH/oh-my-zsh.sh
export LANG=en_US.UTF-8
export PATH="$PATH:/opt/homebrew/opt/libpq/bin:/Users/raian/go/bin"
export MAKEFLAGS=-j4
export FZF_DEFAULT_COMMAND="rg --files --follow --hidden --ignore-file ~/.gitignore"

export PNPM_HOME="/Users/raian/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# bun completions
[ -s "/Users/raian/.bun/_bun" ] && source "/Users/raian/.bun/_bun"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export TMUX_CTRLA=true
export TMUX_STATUSTOP=true
 if [ -z "$TMUX" ]; then
   tmux attach-session || tmux new-session
 fi
