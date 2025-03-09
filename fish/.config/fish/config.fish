# FZF configuration with bat for preview
set -gx FZF_DEFAULT_OPTS "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"

function fzfp
  set base_dir $argv[1]

  if test -z "$base_dir"
    set base_dir "."
  end

  set file (find "$base_dir" -type f -name '.*' -or -type f 2>/dev/null | fzf --preview "bat --color=always {}")

  if test -n "$file"
    # Use $EDITOR or default to nvim if EDITOR is not set
    if set? EDITOR
      $EDITOR "$file"
    else
      nvim "$file"
    end
  end
end

function fcd
  set base_dir $argv[1]
  if test -z "$base_dir"
    set base_dir "."
  end

  set dir (find "$base_dir" -type d -name '.*' -or -type d 2>/dev/null | fzf --preview "ls --color=auto -lh {}")

  if test -n "$dir"
    cd "$dir"
  else
    echo "No directory selected"
  end
end

# Bind Ctrl+F to fzfp.  Note that fish uses different bind syntax
bind \cf fzfp


function fish_greeting

end
