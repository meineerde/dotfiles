if [ -f /etc/bashrc ]; then . /etc/bashrc; fi

# Function to resolve soft links
function delink()
{
  f=$1
  while [ -h "$f" ]; do
    ls=`ls -ld "$f"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then f="$link"
    else f=`dirname "$f"`/"$link"
    fi
  done
  echo $f
}

# General Settings
export DOTFILES=$(dirname `delink ~/.bashrc` )
export PATH="/usr/local/sbin:/usr/local/bin:/opt/local/bin:/Developer/usr/bin:/usr/sbin:/usr/bin:$PATH:/opt/bin:/opt/local/bin"
export PATH="$HOME/bin:$DOTFILES/bin:$PATH"
export PWD_LENGTH=50
set -o notify
shopt -s cdspell >/dev/null 2>&1
shopt -s checkwinsize >/dev/null 2>&1
shopt -s dotglob >/dev/null 2>&1
shopt -s extglob >/dev/null 2>&1
shopt -s hostcomplete >/dev/null 2>&1
shopt -s interactive_comments >/dev/null 2>&1
shopt -u mailwarn >/dev/null 2>&1
shopt -s no_empty_cmd_completion >/dev/null 2>&1
bind Space:magic-space

# Bash History
export HISTIGNORE="&:ls:ll:la:l.:pwd:exit:clear"
export HISTCONTROL=ignoreboth
shopt -s histappend >/dev/null 2>&1


# Load RVM
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# Ruby Settings
export RUBY_VERSION=1.8.7
export RUBYOPT=-rubygems

if [[ -s $HOME/.rvm/scripts/rvm ]] ; then
  source $HOME/.rvm/scripts/rvm ;
fi

# Fix Ruby version
if [[ !`which install_ruby 2>/dev/null` ]] && [[ `which ruby 2>/dev/null` ]]; then
  export RUBY_VERSION=$(ruby --version | sed -e "s/^ruby \(.\..\..\).*$/\1/")
fi

# NVM
[[ -s $HOME/.nvm/nvm.sh ]] && source $HOME/.nvm/nvm.sh

# Disable XON/XOFF flow control (^s/^q).
stty -ixon

# SSH specific config.
if [ -n "$SSH_CLIENT" ]; then
  # show host only if this is an ssh session
  ps1_host="\[\e[01;32m\]\h"
fi

USER_NAME="Holger Just"
USER_EMAIL="web@meine-er.de"
# Setting up git.
if [[ -n $NOPROMPT ]] && [[ -f ~/.gitconfig ]]; then
  if [ "$(git config --global user.name)" != "$USER_NAME" ]; then
    echo "WARNING: git's user.name is $(git config --global user.name)"
  fi
  if [ "$(git config --global user.email)" != "$USER_EMAIL" ]; then
    echo "WARNING: git's user.email is $(git config --global user.email)"
  fi
fi

. $DOTFILES/.git_completion

# OS specific config.
case `uname` in
  Darwin)
    export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Versions/1.6/Home"
    if [ $(which mvim) ]; then
      export EDITOR="mate"
      export SVN_EDITOR="mate -wl1"
    fi
    function fullscreen() { printf "\e[3;0;0;t\e[8;0;0t"; return 0; }
    alias ls='ls -G'

    python="$(which python)"
    python_path=""
    # Find correct python bin path with multiple Pythons installed by Homebrew
    if [[ $(echo "$python" | grep '^/usr/local/bin') ]]; then
      # Python comes from Homebrew
      target=$(readlink "$python")
      if [[ $? ]]; then
        # the python binary is a symlink
        python_path=$(cd "$(dirname "$python")" && cd "$(dirname "$target")" && pwd)
      fi
    fi

    for p in "$python_path" /usr/local/*/bin /usr/*/bin; do
      if [[ -n "$p" ]]; then
        export PATH=$p:$PATH
      fi
    done

    unset p python python_path

    export PG_DATA=/usr/local/var/postgres

    gitx() { open -a GitX $@; }
    pdfman() { man -t $1 | open -a /Applications/Skim.app -f; }

    # Bash completion
    if [ -f `brew --prefix`/etc/bash_completion ]; then
      . `brew --prefix`/etc/bash_completion
    fi

    ;;
  Linux)
    PATH=$PATH:/var/lib/gems/1.8/bin:/var/lib/gems/1.9/bin
    alias ls='ls --color=auto'

    # enable bash completion in interactive shells
    if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
    ;;
  SunOS)
    stty istrip
    export PATH=/opt/csw/bin:/opt/sfw/bin:$PATH:/etc

    if [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi

    # home key
    bind '"\e[1~":beginning-of-line'
    # del key
    bind '"\e[3~":delete-char'
    # end key
    bind '"\e[4~":end-of-line'
    # pgup key
    bind '"\e[5~":history-search-forward'
    # pgdn key
    bind '"\e[6~":history-search-backward'
    ;;
  *) echo "OS unknown to bashrc." ;;
esac

# setting up editor if not yet done
[[ -z "$EDITOR" ]] && EDITOR="nano"
[[ -z "$SVN_EDITOR" ]] && SVN_EDITOR="$EDITOR"
git config --global --replace-all core.editor "$SVN_EDITOR"


# Don't show user name if it's me. make root red.
case $USER in
  hjust) ;;
  *)
    case $UID in
      0) ps1_user="\[\e[01;31m\]\u" ;;
      *) ps1_user="\[\e[01;32m\]\u" ;;
    esac
esac

ps1_host='\h'
ps1_ruby='$(rvm-prompt)'

. $HOME/bin/bash_vcs.sh
ps1_vcs='$(__prompt_command)'
ps1_ruby=' \[\e[0;34m\]$(rvm-prompt v g)\[\e[00m\]'
#ps1_ruby=""

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi
PS1="${debian_chroot:+($debian_chroot)}"

# Short PWD, if it's to long.
short_pwd() {
  FIXED_PWD=$(echo $PWD | sed "s:^$HOME:~:g")
  if [ ${#FIXED_PWD} -gt $(($PWD_LENGTH)) ]; then
    echo "${FIXED_PWD:0:$((4))}...${FIXED_PWD:$((${#PWD}-$PWD_LENGTH+7)):$(($PWD_LENGTH-7))}"
  else
    echo "$FIXED_PWD"
  fi
}
ps1_pwd='\[\e[1;30m\]$(short_pwd)\[\e[00m\]'
#ps1_pwd='\[\e[1;30m\]\W\[\e[00m\]'

# Building $PS1.
if [ -n "$ps1_user" ] && [ -n "$ps1_host" ]; then ps1_user="$ps1_user@"; fi
PS1="$ps1_user$ps1_host"
if [ "$PS1" != "" ]; then PS1="$PS1\[\e[00m\]:"; fi
export PS1="$PS1$ps1_pwd$ps1_vcs$ps1_ruby \$ "


# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# If this is an xterm set the title to user@host:dir.
case "$TERM" in
  xterm*|rxvt*) export PROMPT_COMMAND='echo -ne "\e]0;${USER}@${HOSTNAME}: ${PWD/$HOME/~}\007"' ;;
  *) ;;
esac

# Enable color support. Don't add ls here, it behaves different on Darwin/BSD.
if [ -x /usr/bin/dircolors ]; then eval "`dircolors -b`"; fi
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Some more aliases.
alias ll='ls -Alh'
alias la='ls -A'
alias l='ls -CF'
alias l.="ls -d .*"
alias pdflatex='pdflatex -shell-escape'
alias vi='vim'
alias screen='screen -U'
alias use='rvm use'
alias gems='gem list | less'
alias less='less -R'
alias gsvn='git svn'
alias gdiff='git diff'
alias st='git st'
alias log='git lg'
alias ciam='git ci -am'
alias got='git'
alias goit='git'

alias ss="script/server -b 127.0.0.1"
alias sc="script/console"

alias redcar="wrapped_redcar --fork"

# shorthands - i do this a lot
ruby_version() { if [ -z $1 ]; then echo $RUBY_VERSION; else RUBY_VERSION=$1; fi; }

# if cat is called on a directory, call ls instead
cat() {
  if [ $# = 1 ] && [ -d $1 ]; then
    ls $1
  else
    `which cat` "$@"
  fi
}

# directory for project
d() {
  for dir in $HOME/workspace/$1 $HOME/$1 $1 /Volumes/Finn/$1 $RUBY_PATH/$RUBY_VERSION/lib/ruby/gems/*/gems/$1-*; do
    if [ -d $dir ]; then
      echo $dir
      break
    fi
  done
  unset dir
}

# do stuff with project
with_project() {
  target=$(d $1)
  if [ $target ]; then
    echo $2 $target
    $2 $target
  else
    echo "unknown project"
  fi
  unset target
}

# cd to project
c() { with_project $1 cd; }

# open project in editor
e() { with_project $1 $EDITOR; }

# Enable programmable completion features.
if [ -f /etc/bash_completion ]; then . /etc/bash_completion; fi
if [ -f ~/.tabtab.bash ]; then . ~/.tabtab.bash; fi
set show-all-if-ambiguous on

# Clean up.
unset ps1_user ps1_host ps1_vcs ps_ruby ps1_pwd ps1_ruby script this dir bin
