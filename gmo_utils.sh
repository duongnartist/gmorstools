gmo_dev_pull() {
    git fetch && git checkout develop && git pull
}

gmo_cur_branch() {
    git branch -a | grep "*" | sed 's/* //g'
}

gmo_push() {
    git push origin $(gmo_cur_branch)
}

gmo_add_commit() {
    git add . && git commit -m "$1"
}

gmo_new_branch() {
    git checkout -b "$1"
}

gmo_one_day_ago() {
    date -v-1d +%Y-%m-%d
}

gmo_two_day_ago() {
    date -v-2d +%Y-%m-%d
}

gmo_log() {
    git log --author="duongnt1@runsystem.net" --after=$(gmo_two_day_ago) --before=$(gmo_one_day_ago)
}
