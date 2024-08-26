#!/bin/bash

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

# array of brew packages
declare -a brew_packages=(
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

echo "👉 install fonts"
brew install --cask font-jetbrains-mono-nerd-font

echo "👉 install arc"
brew install --cask arc

echo "👉 install wezterm"
brew install --cask wezterm
brew install --cask font-meslo-lg-nerd-font
curl -L https://gist.githubusercontent.com/auryn31/9490c7a3c1b462672f22faaa8606bf6e/raw/b9dac072be5520443f8e50c86334024db067813b/.wezterm.lua -o ~/.wezterm.lua


echo "🥳 setup nvim"
mv ~/.config/nvim ~/.config/nvim.bak
git clone https://github.com/auryn31/lazyvim.setup.git ~/.config/nvim
echo 'alias vim="nvim"' >>$ZSH_PROFILE

echo "🥳 setup tmux"
mv ~/.tmux.conf ~/.tmux.conf.bak
curl -L https://gist.githubusercontent.com/auryn31/5cecdbad5a0c9c37e49768a518218b98/raw/7469899c168cfb091c20ce8a8c0490e6e770371e/tmux.conf -o ~/.tmux.conf

echo "👉 install dbeaver"
brew install --cask dbeaver-community

echo "👉 install postman"
brew install --cask postman

echo "👉 install insomnia"
brew install --cask insomnia

echo "👉 install atuin"
brew install atuin
echo 'eval "$(atuin init zsh)"' >> $ZSH_PROFILE

echo "👉 install docker"
brew install --cask docker

echo "👉 install oh-my-zsh"
mv ~/.oh-my-zsh ~/.oh-my-zsh.bak
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting


echo "👉 install skdman and java"
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java
brew install maven
brew install gradle

echo "☕️ install caffeine"
brew install --cask domzilla-caffeine

echo "👉 install orbstack"
brew install orbstack

echo "🚀 setup lsd"
{
  echo "alias ls='lsd'"
  echo "alias l='ls -l'"
  echo "alias la='ls -a'"
  echo "alias lla='ls -la'"
  echo "alias lt='ls --tree'"
} >>$ZSH_PROFILE

{
  echo 'ZSH_THEME="Eastwood"'
  echo "plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  brew
  deno
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

