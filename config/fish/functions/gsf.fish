function gsf --description 'fzf でブランチを選んで switch する（リモートのみのブランチも含む）'
    # 候補はローカルとリモート追跡の両方。リモート名を落とした名前を git switch に
    # 渡すと、ローカルに無いブランチは追跡ブランチとして自動作成される（DWIM）。
    #
    # ローカルを先に並べ、同名は先勝ちで重複排除する。
    # refs/remotes/<remote>/HEAD は実体のない参照なので除外する。短縮名だと
    # 単に `origin` になり `/HEAD$` で弾けないため、完全な refname で判定する。
    set -l branches (
        begin
            git for-each-ref --format='%(refname:short)' refs/heads
            git for-each-ref --format='%(refname)' refs/remotes |
                string match --invert --regex '/HEAD$' |
                string replace --regex '^refs/remotes/[^/]+/' ''
        end | awk '!seen[$0]++'
    )
    test -z "$branches"; and return 1

    set -l branch (printf '%s\n' $branches | fzf --height 40% --reverse)
    test -n "$branch"; and git switch $branch
end
