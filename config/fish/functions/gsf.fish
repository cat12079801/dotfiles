function gsf --description 'fzf でブランチを選んで switch する'
    # --format を使うのは、git branch の既定出力に付く現在ブランチの `* ` と
    # インデントを避けるため。そのまま渡すと選択したブランチ名が壊れる。
    set -l branch (git branch --format='%(refname:short)' | fzf --height 40% --reverse)
    test -n "$branch"; and git switch $branch
end
