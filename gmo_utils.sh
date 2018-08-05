tdwelcome() {
  toilet -F gay "Welcome to $(whoami)" | lolcat
  toilet -F gay "today is" | lolcat
  toilet -F gay "$(date '+%D')" | lolcat
  toilet -F gay "$(date '+%T')" | lolcat
}

tddevpull() {
  tdfetch && tdcheckout develop && tdpull
}

tdbranches() {
  git branch -a
}

tdcurbranch() {
  tdbranches | grep "*" | sed 's/* //g'
}

tdfindbranch() {
  tdbranches | grep "$1"
}

tdpush() {
  git push origin $(tdcur_branch)
}

tdmerge() {
  git merge "$1"
}

tdmergedev() {
  tdmerge develop
}

tdcheckout() {
  git checkout "$1"
}

tdaddcommit() {
  git add . && git commit -m "$1"
}

tdnewbranch() {
  git checkout -b "$1"
}

tddiff() {
  git diff
}

tddiffof() {
  tddiff "$1" "$2"
}

tddiffdevcur() {
  tddiff_of develop $(tdcur_branch)
}

tdlogof() {
  git log --author="$1"
}

tdlog() {
  git log --author=$(whoami)
}

tdlogtoday() {
  git log --author=$(whoami) --after=$(tdone_day_ago)
}

tdlogyesterday() {
  git log --author=$(whoami) --after=$(tdtwo_day_ago) --before=$(tdone_day_ago)
}

tdreset() {
  git reset --hard HEAD
}

tdstatus() {
  git status
}

tdpull() {
  git pull
}

tdfetch() {
  git fetch
}

tdonedayago() {
  date -v-1d +%Y-%m-%d
}

tdtwodayago() {
  date -v-2d +%Y-%m-%d
}

tdvideotogif() {
  video_file="$1"
  image_file="${video_file%%.*}.png"
  gif_file="${video_file%%.*}.gif"
  out_fps="${3:-10}"
  out_scale="${2:-320}"
  tdprint "Chuyển đổi từ đoạn phim $video_file này sang ảnh động $gif_file à? 10 lít nhé!"

  ffmpeg -y -i $video_file -vf fps=$out_fps,scale=$out_scale:-1:flags=lanczos,palettegen $image_file

  ffmpeg -i $video_file -i $image_file -filter_complex "fps=$out_fps,scale=$out_scale:-1:flags=lanczos[x];[x][1:v]paletteuse" $gif_file
  rm $image_file

  tdprint "Chuyển khoản vào số tài khoản Vietcombank của ${whoami} nhé!"
}

tddatetime() {
  clear
  tdprint "Hỏi giờ á? Để xem nào!"
  sleep 2
  clear
  while true; do clear; tdprint "$(date '+%D %T')"; tdprint "Sắp đến giờ về chưa?"; sleep 1; done
  tdprint "Sắp đến giờ về chưa?"
}

tdfetchall() {
  tdprint "Úi chà kéo hết về á? Đi xuống tầng 4 mua lon Cocacola lên đây đi!"
  git branch -a | grep remotes/origin/ | grep -v HEAD | sed -e 's/  remotes\/origin\//git reset --hard HEAD \&\& git checkout /g' > ../${PWD##*/}.sh && source ../${PWD##*/}.sh && rm ../${PWD##*/}.sh
  tdprint "Uống hết mấy lon rồi? Lâu quá phải không?"
}
# crawl web
# $1: text contain in sub url
# $2: parent url
# $3: path to save file
tdcrawl() {
  text_contain="$1"
  parent_url="$2"
  download_to="$3"
  file_name="gg.temp"
  tdprint "Đang crawl nội dung..."
  file_list=$(lynx -dump $parent_url | awk '/http/{print $2}' | grep $text_contain) | sort -u
  tdprint "Lưu các link trên vào file $file_name"
  tdprint $file_list
  echo $file_list > $file_name
  tdprint "Đang download các file trên về thư mục $download_to ..."
  wget -q -i $file_name -P $download_to
  tdprint "Xóa tệp $file_name"
  rm $file_name
  tdprint "Xong phim!"
}

tdprint() {
  echo "$1" | toilet -f term -F border --gay
}

tddownload() {
    youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' -o "$2" "$1"
}

tdconverttobaseline() {
  ffmpeg -i "$1" \
        -c:v libx264 -preset slow -crf 22 \
        -profile:v baseline -level 3.0 \
        -movflags +faststart -pix_fmt yuv420p \
        "$2"
}

tdsplitvideo() {
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

function tdresetdock {
  defaults write com.apple.dock ResetLaunchPad -bool true; killall Dock
}

function tdenablebuildtime {
  defaults write com.apple.dt.Xcode ShowBuildOperationDuration YES
}
