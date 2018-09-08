baseUrl=http://www.codethemes.net/themes/popular/all/
FOLDER_NAME="themes"
rm -rf $FOLDER_NAME
mkdir $FOLDER_NAME
cd $FOLDER_NAME
echo "-> Created folder: $FOLDER_NAME"
for i in `seq 1 7`; do
	url="$baseUrl$i"
	echo "-> Start Fetching: $url"
	FILE_NAME="urls_$i.tmp"
	lynx --dump $url | grep '.dvtcolortheme' | awk '/http/{print $2}' > $FILE_NAME
	sed -i -e 's/%3A/:/g' $FILE_NAME
	sed -i -e 's/%2F/\//g' $FILE_NAME
	sed -i -e 's/themeinstaller:\/\/install\///g' $FILE_NAME
	sed -i -e 's/install/public\/themes/g' $FILE_NAME
	echo "-> Start downloading: $FILE_NAME"
	wget -q -i $FILE_NAME
	rm *tmp*
	TOTAL_FILES=`ls | grep ".dvtcolortheme" | wc -l`
	echo "-> Downloaded: $TOTAL_FILES files"
done
themeFolder=~/Library/Developer/Xcode/UserData/FontAndColorThemes/
rm -rf $themeFolder
mkdir -p $themeFolder
cp *.dvtcolortheme $themeFolder
cd ..
rm -rf $FOLDER_NAME
echo "-> Deleted folder: $FOLDER_NAME"
killall Xcode
open ~/../../Applications/Xcode.app
