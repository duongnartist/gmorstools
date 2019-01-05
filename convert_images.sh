OUTPUT_FOLDER='~/Desktop/kanji'
rm -rf $OUTPUT_FOLDER
mkdir OUTPUT_FOLDER
cd ~/Desktop/Chineasy\ Cards_v1.11.1_apkpure.com/res/drawable
FILES="$(find *.webp)"
for FILE in $FILES
do
	PATH="${FILE//webp/png}"
	echo "+ ${FILE} -> ${PATH}"
	/usr/local/bin/dwebp $FILE -o $PATH
	/usr/local/bin/convert $PATH -background white -gravity southeast -extent 1920x1080 "../bg_${PATH}"
done