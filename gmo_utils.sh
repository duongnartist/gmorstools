gg_dev_pull() {
    git fetch && git checkout develop && git pull
}

gg_cur_branch() {
    git branch -a | grep "*" | sed 's/* //g'
}

gg_push() {
    git push origin $(gg_cur_branch)
}

gg_add_commit() {
    git add . && git commit -m "$1"
}

gg_new_branch() {
    git checkout -b "$1"
}

gg_one_day_ago() {
    date -v-1d +%Y-%m-%d
}

gg_two_day_ago() {
    date -v-2d +%Y-%m-%d
}

gg_log() {
    git log --author="duongnt1@runsystem.net" --after=$(gg_two_day_ago) --before=$(gg_one_day_ago)
}

gg_reset() {
    git reset --hard HEAD
}
