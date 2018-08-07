[ -f ~/.profile ] && . ~/.profile
[ -f ~/.bashrc ] && . ~/.bashrc

BASE16_SCHEME="tomorrow"
BASE16_SHELL="$DOTFILES/base16-shell/base16-$BASE16_SCHEME.dark.sh"
[[ -s "$BASE16_SHELL" ]] && . "$BASE16_SHELL"
