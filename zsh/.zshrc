# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path setup
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export EDITOR="nvim"
export VISUAL="$EDITOR"

# Zsh options
setopt autocd              # cd by typing directory name
setopt noclobber           # prevent overwrite with '>'
setopt no_beep
setopt hist_ignore_dups
setopt share_history

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# Locale
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Oh-my-zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Prompt config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Aliases
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias c='clear'
alias grep='grep --color=auto'

# Project shortcuts
alias dotf='cd ~/dotfiles'
alias dev='cd ~/dev'

# Safe file operations
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}


export PATH="$HOME/opt/cross/bin/:$PATH"
