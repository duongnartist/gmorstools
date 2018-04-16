echo "Hello $USER Welcome to Time Log from git"
echo "Current folder: `pwd`"
BRANCHES="$`git branch -a`"
# echo $BRANCHES

mails=$(echo $BRANCHES | tr ";" "\n")

for addr in $mails
do
    echo $addr
done