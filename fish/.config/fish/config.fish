# FZF configuration with bat for preview
set -gx FZF_DEFAULT_OPTS "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"

# If you want to use bat for CTRL+T file search
set -gx FZF_CTRL_T_OPTS "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"

# For directory preview with CTRL+T you might want to use ls or exa/eza
set -gx FZF_ALT_C_OPTS "--preview 'ls -la {}'"

# For the Fish plugin
set -g fzf_preview_file_cmd "bat --style=numbers --color=always"
set -g fzf_preview_dir_cmd "ls -la"

function fish_greeting

end
