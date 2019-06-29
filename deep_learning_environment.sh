# Setting up deep learning environment the easy way on macOS High Sierra

# 1. Getting HomeBrew
/usr/bin/ruby -e “$(curl -	fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# 2. Python 3

brew install python3
brew install pip3
pip3 -V

# 3. Virtual Environment

pip3 install virtualenv virtualenvwrapper

vim ~/.bash_profile

# virtualenv and virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
source /usr/local/bin/virtualenvwrapper.sh