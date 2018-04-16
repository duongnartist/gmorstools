X_CODE_PIDS=$(ps aux | grep 'Xcode' | awk '{print $2}')
if [ -z "$X_CODE_PIDS" ]; then
    echo "XCode is not running..."
else
    echo "XCode is running..."
    echo "Killing XCode..."
    kill "$X_CODE_PIDS"
fi
echo "Opening XCode..."
open -a xcode