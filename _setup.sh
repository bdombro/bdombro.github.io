/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo "export PATH=/usr/local/bin:\$PATH" >> ~/.bashrc
export PATH=/usr/local/bin:$PATH
brew update

# Imagegick
brew install -g imagemagick

# Ruby
brew install rbenv
brew install ruby-build
rbenv install 2.4.0
rbenv local 2.4.0
rbenv rehash
echo "export PATH=~/.rbenv/versions/2.4.0/bin/:\$PATH" >> ~/.bashrc
echo "export PATH=~/.rbenv/versions/2.4.0/bin/:\$PATH" >> ~/.profile
export PATH=~/.rbenv/versions/2.4.0/bin/:$PATH
bundle install

# Node
brew install node
npm install -g jpegtran
npm install -g gulp
npm install -g cf-cli
npm install -g http-server
npm install

echo ""
echo "All set! Now you can do most anything you want using the gulp command. See the gulpfile for more info."
echo ""