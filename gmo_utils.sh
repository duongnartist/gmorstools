gg_dev_pull() {
    gg_fetch && gg_checkout develop && gg_pull
}

gg_cur_branch() {
    git branch -a | grep "*" | sed 's/* //g'
}

gg_push() {
    git push origin $(gg_cur_branch)
}

gg_merge() {
    git merge "$1"
}

gg_checkout() {
    git checkout "$1"
}

gg_add_commit() {
    git add . && git commit -m "$1"
}

gg_new_branch() {
    git checkout -b "$1"
}

gg_log_of() {
    git log --author="$1"
}

gg_log() {
    git log --author=$(whoami)
}

gg_log_today() {
    git log --author=$(whoami) --after=$(gg_one_day_ago)
}

gg_log_yesterday() {
    git log --author=$(whoami) --after=$(gg_two_day_ago) --before=$(gg_one_day_ago)
}

gg_reset() {
    git reset --hard HEAD
}

gg_status() {
    git status
}

gg_pull() {
    git pull
}

gg_fetch() {
    git fetch
}

gg_one_day_ago() {
    date -v-1d +%Y-%m-%d
}

gg_two_day_ago() {
    date -v-2d +%Y-%m-%d
}

gg_kmk_ios() {
    cd ~/Desktop/projects/kmk_ios
}

gg_kmk_doc() {
    cd ~/Desktop/projects/kmk_documents
}

gg_video_to_gif() {
    ffmpeg -y -i "${1}" -vf fps=${3:-10},scale=${2:-320}:-1:flags=lanczos,palettegen "${1}.png"
    ffmpeg -i "${1}" -i "${1}.png" -filter_complex "fps=${3:-10},scale=${2:-320}:-1:flags=lanczos[x];[x][1:v]paletteuse" "${1}".gif
    rm "${1}.png"
}
