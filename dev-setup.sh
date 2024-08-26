echo "🚀 Starting Dev Setup"

INSTALL_FOLDER=~/.macsetup
mkdir -p $INSTALL_FOLDER
ZSH_PROFILE="$INSTALL_FOLDER/zshrc"

echo "👉 install brew..."
if ! hash brew
then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew update
fi

echo "🌱 ...brew installed"

declare -a brew_packages=(
"atuin"
"coreutils"
"bash"
"ffmpeg"
"fzf"
"curl"
"git"
"wget"
"zsh"
"zsh-autosuggestions"
"zsh-syntax-highlighting"
"tree"
"lsd"
"jq"
"neovim"
"tmux"
"fabric"
"orbstack"
)

for package in "${brew_packages[@]}"
do
  if ! brew list $package > /dev/null
  then
    brew install $package
  fi
  echo "🌱 ...$package installed"
done

echo "👉 install node/js"
mkdir ~/.nvm
brew install nvm
brew install node 
brew install yarn

echo "🚀 install casks"
declare -a cask_packages=(
"arc"
"docker"
"domzilla-caffeine"
"dozer"
"dbeaver-community"
"font-jetbrains-mono-nerd-font"
"font-meslo-lg-nerd-font"
"insomnia"
"postman"
"spotify"
"whatsapp"
"wezterm"
)

for cask in "${cask_packages[@]}"
do
  if [[ ! -d "/Applications/$cask.app" ]]; then
    # install APP-TO-CHECK
    brew install --cask $cask
  fi
  echo "🌱 ...$cask installed"
done

echo "👉 setup wezterm"
curl -L https://gist.githubusercontent.com/auryn31/9490c7a3c1b462672f22faaa8606bf6e/raw/b9dac072be5520443f8e50c86334024db067813b/.wezterm.lua -o ~/.wezterm.lua


echo "🥳 setup nvim"
mv ~/.config/nvim ~/.config/nvim.bak
git clone https://github.com/auryn31/lazyvim.setup.git ~/.config/nvim
echo 'alias vim="nvim"' >>$ZSH_PROFILE

echo "🥳 setup tmux"
mv ~/.tmux.conf ~/.tmux.conf.bak
curl -L https://gist.githubusercontent.com/auryn31/5cecdbad5a0c9c37e49768a518218b98/raw/70bbe17e09ce35ceff72c65dd3eb5df4e181b596/tmux.conf -o ~/.tmux.conf

echo "👉 setup atuin"
echo 'eval "$(atuin init zsh)"' >> $ZSH_PROFILE

echo "👉 install oh-my-zsh"
mv ~/.oh-my-zsh ~/.oh-my-zsh.bak
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting


echo "👉 install skdman and java"
if [ -d "$HOME/.sdkman" ]; then
  echo "🌱 ...sdkman already installed"
else
  curl -s "https://get.sdkman.io" | bash
  source "$HOME/.sdkman/bin/sdkman-init.sh"
fi
sdk install java
brew install maven
brew install gradle

echo "🚀 setup lsd"
{
  echo "alias ls='lsd'"
  echo "alias l='ls -l'"
  echo "alias la='ls -a'"
  echo "alias lla='ls -la'"
  echo "alias lt='ls --tree'"
} >>$ZSH_PROFILE

echo "🌊 installing typescript globally..."
npm install -g typescript

{
  echo "source \$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  echo 'ZSH_THEME="Eastwood"'
  echo "plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  brew
  docker
  mvn
  yarn
)
"
echo 'source $ZSH/oh-my-zsh.sh'
} >>$ZSH_PROFILE

{
  echo "source $ZSH_PROFILE # alias and things added by mac_setup script"
}>>"$HOME/.zshrc"
source "$HOME/.zshrc"

echo "💻 configure OSx"

echo "  📌 Trackpad: enable tap to click for this user and for the login screen"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "  📌 Trackpad: drag and move with three fingers --> Require restart"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true


echo "  📌 Increase window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

echo "  📌 Disable the 'Are you sure you want to open this application?' dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false

echo "  📌 Disable auto-correct"
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

echo "  📌 Save screenshots to the desktop"
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

echo "  📌 Show filename extensions by default"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

echo "  📌 Show hidden files"
defaults write com.apple.Finder AppleShowAllFiles true

killall Finder

echo "🚀 Dev Setup Done! 🎉🎉🎉"
echo "Note that some of these changes require a logout/restart to take effect."
