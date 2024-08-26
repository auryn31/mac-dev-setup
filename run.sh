if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
  echo "🥳 setup with zsh"
  zsh dev-setup.sh
elif [ -n "`$SHELL -c 'echo $BASH_VERSION'`" ]; then
  echo "🥲 setup with sh"
  sh dev-setup.sh
else
  echo "☹️ you tried to run this script with an unsupported shell. Please run it with bash or zsh."
fi
