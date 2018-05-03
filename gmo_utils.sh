gmo_dev_pull() {
    git checkout develop && git pull
}

gmo_cur_branch() {
    git branch -a | grep "*" | sed 's/* //g'
}

gmo_push() {
    git push origin $(gmo_cur_branch)
}