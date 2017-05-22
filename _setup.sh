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
gem install bundle
bundle install

# Node
brew install node
# Note: Warnings are acceptable for the npm install commands
npm install -g jpegtran gulp cf-cli http-server
npm install

echo ""
echo "All set! Now you can do most anything you want using the gulp command."
echo "For example, use `gulp serve` to (1) watch the source files, (2) compile the source files on change, (3) run a local server at http://localhost:3000, (4) open the url in Chrome browser, (5) auto-refresh the browser on change."
echo "See the gulpfile for more info."
echo ""