alias lg=lazygit

# Change to a git repository's root directory from anywhere inside it
function cdr() {
  inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
  if [ $inside_git_repo ]; then
    cd `git rev-parse --show-toplevel`
  else
    echo "Not a git project"
  fi
}

# From https://seb.jambor.dev/posts/improving-shell-workflows-with-fzf/
function pr-checkout() {
  local jq_template pr_number

  jq_template='"'\
'#\(.number) - \(.user.login) - \(.title)'\
'\t'\
'Author: \(.user.login)\n'\
'Created: \(.created_at)\n'\
'Updated: \(.updated_at)\n\n'\
'\(.body)'\
'"'

  pr_number=$(
    gh api 'repos/:owner/:repo/pulls' |
    jq ".[] | $jq_template" |
    sed -e 's/"\(.*\)"/\1/' -e 's/\\t/\t/' |
    fzf \
      --with-nth=1 \
      --delimiter='\t' \
      --preview='echo -e {2}' \
      --preview-window=top:wrap |
    sed 's/^#\([0-9]\+\).*/\1/'
  )

  if [ -n "$pr_number" ]; then
    gh pr checkout "$pr_number"
  fi
}
