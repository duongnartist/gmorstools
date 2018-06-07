gg_welcome() {
  gg_print "Chúc $(whoami) một ngày mới tốt lành!"
}

gg_dev_pull() {
  gg_print "Pull develop về đi anh em!"
  gg_fetch && gg_checkout develop && gg_pull
  gg_print "Rồi! Giờ muốn làm gì thì làm đi!"
}

gg_branches() {
  git branch -a
}

gg_cur_branch() {
  cur_branch=${gg_branches | grep "*" | sed 's/* //g'}
  gg_print "Branch hiện tại là $cur_branch"
}

gg_find_branch() {
    gg_branches | grep "$1"
}

gg_push() {
    git push origin $(gg_cur_branch)
}

gg_merge() {
    git merge "$1"
}

gg_merge_dev() {
    gg_merge develop
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

gg_diff() {
    git diff
}

gg_diff_of() {
  gg_diff "$1" "$2"
}

gg_diff_dev_cur() {
  gg_diff_of develop $(gg_cur_branch)
}

gg_log_of() {
  gg_print "Check git của $1 nào!"
  git log --author="$1"
}

gg_log() {
  gg_print "$(whoami) đã làm những gì nào?"
  git log --author=$(whoami)
}

gg_log_today() {
  gg_print "Hôm nay $(whoami) đã làm được những gì nào?"
  git log --author=$(whoami) --after=$(gg_one_day_ago)
}

gg_log_yesterday() {
  gg_print "Hôm qua $(whoami) đã làm được những gì nào?"
  git log --author=$(whoami) --after=$(gg_two_day_ago) --before=$(gg_one_day_ago)
}

gg_reset() {
  gg_print "Đừng có xóa mạnh mẽ thế chứ?"
  git reset --hard HEAD
  gg_print "Ôi méo kịp!"
}

gg_status() {
  gg_print "Bây giờ git đang làm cái méo gì thế?"
  git status
}

gg_pull() {
  gg_print "Hò zô ta kéo git về!"
  git pull
  gg_print "Kéo git mệt vl ra!"
}

gg_fetch() {
  gg_print "Kiểm tra xem git có cái méo gì mới không?"
  git fetch
  gg_print "Cũng có cái gì đó gọi là mơi mới đó!"
}

gg_one_day_ago() {
  date -v-1d +%Y-%m-%d
}

gg_two_day_ago() {
  date -v-2d +%Y-%m-%d
}

gg_kmk_ad() {
  gg_print "Lại vào KMK Beauty Passport Android nào!"
  cd ~/Desktop/projects/kmk_ad
}

gg_kmk_ios() {
  gg_print "Lại vào KMK Beauty Passport iOS nào!"
  cd ~/Desktop/projects/kmk_ios
}

gg_kmk_doc() {
  gg_print "Lại vào KMK Beauty Passport Documents nào!"
  cd ~/Desktop/projects/kmk_documents
}

gg_video_to_gif() {
  video_file="$1"
  image_file="${video_file%%.*}.png"
  gif_file="${video_file%%.*}.gif"
  out_fps="${3:-10}"
  out_scale="${2:-320}"
  gg_print "Chuyển đổi từ đoạn phim $video_file này sang ảnh động $gif_file à? 10 lít nhé!"

  ffmpeg -y -i $video_file -vf fps=$out_fps,scale=$out_scale:-1:flags=lanczos,palettegen $image_file

  ffmpeg -i $video_file -i $image_file -filter_complex "fps=$out_fps,scale=$out_scale:-1:flags=lanczos[x];[x][1:v]paletteuse" $gif_file
    rm $image_file

  gg_print "Chuyển khoản vào số tài khoản Vietcombank của ${whoami} nhé!"
}

gg_date_time() {
  gg_print "Hỏi giờ á? Để xem nào!"
  sleep 2
  clear
  while true; do echo "$(date '+%D %T' | toilet -f term -F border --gay)"; sleep 1; done
  gg_print "Sắp đến giờ về chưa?"
}

gg_fetch_all() {
  gg_print "Úi chà kéo hết về á? Đi xuống tầng 4 mua lon Cocacola lên đây đi!"
  git branch -a | grep remotes/origin/ | grep -v HEAD | sed -e 's/  remotes\/origin\//git reset --hard HEAD \&\& git checkout /g' > ../${PWD##*/}.sh && source ../${PWD##*/}.sh && rm ../${PWD##*/}.sh
  gg_print "Uống hết mấy lon rồi? Lâu quá phải không?"
}
# crawl web
# $1: text contain in sub url
# $2: parent url
# $3: path to save file
gg_crawl() {
  text_contain="$1"
  parent_url="$2"
  download_to="$3"
  file_name="gg.temp"
  gg_print "Đang crawl nội dung..."
  file_list=$(lynx -dump $parent_url | awk '/http/{print $2}' | grep $text_contain)
  gg_print "Lưu các link trên vào file $file_name"
  gg_print $file_list
  echo $file_list > $file_name
  gg_print "Đang download các file trên về thư mục $download_to ..."
  wget -q -i $file_name -P $download_to
  gg_print "Xóa tệp $file_name"
  rm $file_name
  gg_print "Xong phim!"
}

gg_print() {
  echo "$1" | toilet -f term -F border --gay
}

gg_welcome
