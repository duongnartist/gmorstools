td_welcome() {
  toilet -F gay "Welcome to $(whoami)" | lolcat
  toilet -F gay "today is" | lolcat
  toilet -F gay "$(date '+%D')" | lolcat
  toilet -F gay "$(date '+%T')" | lolcat
}

td_dev_pull() {
  td_fetch && td_checkout develop && td_pull
}

td_branches() {
  git branch -a
}

td_cur_branch() {
  td_branches | grep "*" | sed 's/* //g'
}

td_find_branch() {
  td_branches | grep "$1"
}

td_push() {
  git push origin $(td_cur_branch)
}

td_merge() {
  git merge "$1"
}

td_merge_dev() {
  td_merge develop
}

td_checkout() {
  git checkout "$1"
}

td_add_commit() {
  git add . && git commit -m "$1"
}

td_new_branch() {
  git checkout -b "$1"
}

td_diff() {
  git diff
}

td_diff_of() {
  td_diff "$1" "$2"
}

td_diff_dev_cur() {
  td_diff_of develop $(td_cur_branch)
}

td_log_of() {
  git log --author="$1"
}

td_log() {
  git log --author=$(whoami)
}

td_log_today() {
  git log --author=$(whoami) --after=$(td_one_day_ago)
}

td_log_yesterday() {
  git log --author=$(whoami) --after=$(td_two_day_ago) --before=$(td_one_day_ago)
}

td_reset() {
  git reset --hard HEAD
}

td_status() {
  git status
}

td_pull() {
  git pull
}

td_fetch() {
  git fetch
}

td_one_day_ago() {
  date -v-1d +%Y-%m-%d
}

td_two_day_ago() {
  date -v-2d +%Y-%m-%d
}

td_kmk_ad() {
  cd ~/Desktop/projects/kmk_ad
}

td_kmk_ios() {
  cd ~/Desktop/projects/kmk_ios
}

td_kmk_doc() {
  cd ~/Desktop/projects/kmk_documents
}

td_video_to_gif() {
  video_file="$1"
  image_file="${video_file%%.*}.png"
  gif_file="${video_file%%.*}.gif"
  out_fps="${3:-10}"
  out_scale="${2:-320}"
  td_print "Chuyển đổi từ đoạn phim $video_file này sang ảnh động $gif_file à? 10 lít nhé!"

  ffmpeg -y -i $video_file -vf fps=$out_fps,scale=$out_scale:-1:flags=lanczos,palettegen $image_file

  ffmpeg -i $video_file -i $image_file -filter_complex "fps=$out_fps,scale=$out_scale:-1:flags=lanczos[x];[x][1:v]paletteuse" $gif_file
  rm $image_file

  td_print "Chuyển khoản vào số tài khoản Vietcombank của ${whoami} nhé!"
}

td_date_time() {
  clear
  td_print "Hỏi giờ á? Để xem nào!"
  sleep 2
  clear
  while true; do clear; td_print "$(date '+%D %T')"; td_print "Sắp đến giờ về chưa?"; sleep 1; done
  td_print "Sắp đến giờ về chưa?"
}

td_fetch_all() {
  td_print "Úi chà kéo hết về á? Đi xuống tầng 4 mua lon Cocacola lên đây đi!"
  git branch -a | grep remotes/origin/ | grep -v HEAD | sed -e 's/  remotes\/origin\//git reset --hard HEAD \&\& git checkout /g' > ../${PWD##*/}.sh && source ../${PWD##*/}.sh && rm ../${PWD##*/}.sh
  td_print "Uống hết mấy lon rồi? Lâu quá phải không?"
}
# crawl web
# $1: text contain in sub url
# $2: parent url
# $3: path to save file
td_crawl() {
  text_contain="$1"
  parent_url="$2"
  download_to="$3"
  file_name="gg.temp"
  td_print "Đang crawl nội dung..."
  file_list=$(lynx -dump $parent_url | awk '/http/{print $2}' | grep $text_contain) | sort -u
  td_print "Lưu các link trên vào file $file_name"
  td_print $file_list
  echo $file_list > $file_name
  td_print "Đang download các file trên về thư mục $download_to ..."
  wget -q -i $file_name -P $download_to
  td_print "Xóa tệp $file_name"
  rm $file_name
  td_print "Xong phim!"
}

td_print() {
  echo "$1" | toilet -f term -F border --gay
}

td_download() {
    youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' -o "$2" "$1"
}

td_convert_to_baseline() {
  ffmpeg -i "$1" \
        -c:v libx264 -preset slow -crf 22 \
        -profile:v baseline -level 3.0 \
        -movflags +faststart -pix_fmt yuv420p \
        "$2"
}

td_split_video() {
  IN_FILE="$1"
  OUT_FILE_FORMAT="$3"
  typeset -i CHUNK_LEN
  CHUNK_LEN="$2"

  DURATION_HMS=$(ffmpeg -i "$IN_FILE" 2>&1 | grep Duration | cut -f 4 -d ' ')
  DURATION_H=$(echo "$DURATION_HMS" | cut -d ':' -f 1)
  DURATION_M=$(echo "$DURATION_HMS" | cut -d ':' -f 2)
  DURATION_S=$(echo "$DURATION_HMS" | cut -d ':' -f 3 | cut -d '.' -f 1)
  let "DURATION = ( DURATION_H * 60 + DURATION_M ) * 60 + DURATION_S"

  if [ "$DURATION" = '0' ] ; then
          echo "Invalid input video"
          usage
          exit 1
  fi

  if [ "$CHUNK_LEN" = "0" ] ; then
          echo "Invalid chunk size"
          usage
          exit 2
  fi

  if [ -z "$OUT_FILE_FORMAT" ] ; then
          FILE_EXT=$(echo "$IN_FILE" | sed 's/^.*\.\([a-zA-Z0-9]\+\)$/\1/')
          FILE_NAME=$(echo "$IN_FILE" | sed 's/^\(.*\)\.[a-zA-Z0-9]\+$/\1/')
          OUT_FILE_FORMAT="${FILE_NAME}-%03d.${FILE_EXT}"
          echo "Using default output file format : $OUT_FILE_FORMAT"
  fi

  N='1'
  OFFSET='0'
  let 'N_FILES = DURATION / CHUNK_LEN + 1'

  while [ "$OFFSET" -lt "$DURATION" ] ; do
          OUT_FILE=$(printf "$OUT_FILE_FORMAT" "$N")
          echo "writing $OUT_FILE ($N/$N_FILES)..."
          ffmpeg -i "$IN_FILE" -vcodec copy -acodec copy -ss "$OFFSET" -t "$CHUNK_LEN" "$OUT_FILE"
          let "N = N + 1"
          let "OFFSET = OFFSET + CHUNK_LEN"
  done
}

function usage {
        echo "Usage : ffsplit.sh input.file chunk-duration [output-filename-format]"
        echo -e "\t - input file may be any kind of file reconginzed by ffmpeg"
        echo -e "\t - chunk duration must be in seconds"
        echo -e "\t - output filename format must be printf-like, for example myvideo-part-%04d.avi"
        echo -e "\t - if no output filename format is given, it will be computed\
 automatically from input filename"
}

function td_reset_dock {
  defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock
}

function td_enable_build_time {
  defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES
}

td_welcome
