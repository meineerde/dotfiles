[[ -f "$HOME/.bash_profile_env" ]] && . "$HOME/.bash_profile_env"

# Function to resolve soft links
function delink()
{
  local f="$1"
  local ls link
  while [[ -h "$f" ]]; do
    ls="$(ls -ld "$f")"
    link="$(expr "$ls" : '.*-> \(.*\)$')"
    if expr "$link" : '/.*' > /dev/null; then
      f="$link"
    else
      f="$(dirname "$f")/${link}"
    fi
  done
  echo "$f"
}

# General Settings
DOTFILES="$(dirname "$(delink ~/.bashrc)")"
export DOTFILES
export PATH="${DOTFILES}/bin:${PATH}"
export PWD_LENGTH=50

# Set locale to en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

set -o notify
shopt -s cdspell >/dev/null 2>&1
shopt -s checkwinsize >/dev/null 2>&1
shopt -s dotglob >/dev/null 2>&1
shopt -s extglob >/dev/null 2>&1
shopt -s hostcomplete >/dev/null 2>&1
shopt -s interactive_comments >/dev/null 2>&1
shopt -u mailwarn >/dev/null 2>&1
shopt -s no_empty_cmd_completion >/dev/null 2>&1
# https://relentlesscoding.com/posts/bash-magic-space/
shopt -s histverify

# Bash History
export HISTIGNORE="&:ls:ll:la:l.:pwd:exit:clear"
export HISTCONTROL=ignoreboth
export HISTSIZE=1000
# never ending history file
export HISTFILESIZE=""
shopt -s histappend >/dev/null 2>&1

# Base16 Shell Theme
base16_theme="${DOTFILES}/base16-shell/scripts/base16-tomorrow-night.sh"
. "$base16_theme"
alias reset="command reset && . \"${base16_theme}\""

# Editor
if [[ -x /usr/local/bin/zed ]]; then
  export EDITOR="/usr/local/bin/zed -w"
  export BACKGROUND_EDITOR="/usr/local/bin/zed -n"
elif [[ -x /usr/local/bin/atom ]]; then
  export EDITOR="/usr/local/bin/atom -nw"
  export BACKGROUND_EDITOR="/usr/local/bin/atom -n"
else
  export EDITOR="nano"
  export BACKGROUND_EDITOR="$EDITOR"
fi
export GIT_EDITOR="$EDITOR"
export SVN_EDITOR="$EDITOR"

# SSH specific config.
if [[ -n "$SSH_CLIENT" ]]; then
  # show host only if this is an ssh session
  ps1_host="\[\e[01;32m\]\h"
fi

# Only if we are in an interactive session
if [[ $- =~ 'i' ]]; then
  # Disable XON/XOFF flow control (^s/^q).
  stty -ixon
fi

# OS specific config.
case "$(uname)" in
  Darwin)
    # Homebrew
    [[ -x /usr/local/bin/brew ]] && eval "$(/usr/local/bin/brew shellenv)"
    [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

    # Bash completion
    if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]; then
      . "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
    fi
    ;;
esac

if [[ -r /etc/bash_completion ]]; then . /etc/bash_completion; fi
set show-all-if-ambiguous on

# Rust
if [[ -d "$HOME/.cargo/bin" ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Perl
export PATH="$HOME/perl5/bin${PATH:+:${PATH}}"
export PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"
export PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"
export PERL_MB_OPT="--install_base \"$HOME/perl5\""
export PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"

# Ruby
if [[ -r "${HOME}/workspace/chruby/share/chruby/chruby.sh" ]]; then
  chruby_prefix="${HOME}/workspace/chruby"
  PATH="${chruby_prefix}/bin:${PATH}"
elif [[ -r "${HOMEBREW_PREFIX}/share/chruby/chruby.sh" ]]; then
  chruby_prefix="${HOMEBREW_PREFIX}"
fi
if [[ -n "${chruby_prefix:-}" ]]; then
  . "${chruby_prefix}/share/chruby/chruby.sh"
  . "${chruby_prefix}/share/chruby/auto.sh"

  unset chruby_prefix
  alias cr=chruby
elif [[ -s "${HOME}/.rvm/scripts/rvm" ]]; then
  . "${HOME}/.rvm/scripts/rvm"
  # tab completion for RVM
  [[ -r "${rvm_path}/scripts/completion" ]] && . "${rvm_path}/scripts/completion"
  PATH="${PATH}:${HOME}/.rvm/bin" # Add RVM to PATH for scripting
fi

alias be="bundle exec"
alias rs="bundle exec rails server -b 127.0.0.1"
alias rc="bundle exec rails console"

ss() { if [[ -x script/server ]]; then bundle exec script/server webrick -b 127.0.0.1 "$@"; else rs "$@"; fi }
sc() { if [[ -x script/console ]]; then bundle exec script/console "$@"; else rc "$@"; fi }

# NVM
if [[ -d "${HOME}/.nvm" ]]; then
  export NVM_DIR="${HOME}/.nvm"
  [ -s "${NVM_DIR}/nvm.sh" ] && . "${NVM_DIR}/nvm.sh" --no-use
  [ -s "${NVM_DIR}/bash_completion" ] && . "${NVM_DIR}/bash_completion"
fi

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
if ! command -v pyenv 1>/dev/null 2>&1 && [[ -d "$PYENV_ROOT/bin" ]]; then
  export PATH="$PYENV_ROOT/bin:$PATH"
fi
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv init --path)"
fi

# Git
alias g=git
[[ -n "$BASH_COMPLETION" ]] && __git_complete g __git_main
alias got='git'
[[ -n "$BASH_COMPLETION" ]] && __git_complete got __git_main
alias goit='git'
[[ -n "$BASH_COMPLETION" ]] && __git_complete goit __git_main
alias gdiff='git diff'
[[ -n "$BASH_COMPLETION" ]] && __git_complete gdiff _git_diff
alias st='git status'
[[ -n "$BASH_COMPLETION" ]] && __git_complete gdiff _git_status
alias log='git lg'
[[ -n "$BASH_COMPLETION" ]] && __git_complete log _git_log
alias cm='git commit -m'
[[ -n "$BASH_COMPLETION" ]] && __git_complete cm _git_commit
alias ga='git add -p'
[[ -n "$BASH_COMPLETION" ]] && __git_complete ga _git_add

ghead() { git rev-parse --verify "${1:-HEAD}"; }

# Planio
export PLANIO_SKIP_AMA=1

# Enable color support
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ls='ls --color=auto'

# Some more aliases.
alias ll='ls --color=auto -Alh'
alias screen='screen -U'
alias less='less -R'

alias ssh-insecure='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
[[ -n "$BASH_COMPLETION" ]] && complete -o default -o nospace -F _ssh ssh-insecure

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Some useful helper functions
http() {
  port="${1:-8000}"
  if type python3 >/dev/null 2>&1; then
    python3 -m http.server "$port"
  else
    python -m SimpleHTTPServer "$port"
  fi
}

# if cat is called on a directory, call ls instead
cat() {
  if [[ $# = 1 ]] && [[ -d $1 ]]; then
    ls "$1"
  else
    /usr/bin/env cat "$@"
  fi
}

# directory for project
project_dirs() {
  local dirs="__path__:$HOME/workspace/__path__:$HOME/__path__:$GEM_HOME/gems/__gempath__:$GEM_HOME/gems/__path__:$GEM_HOME/bundler/gems/__gempath__:$GEM_HOME/bundler/gems/__path__"
  if [[ -n "$1" ]]; then
    dirs="${dirs//__gempath__/__path__-*}"
    echo "${dirs//__path__/$1}"
  else
    dirs="${dirs//\/__gempath__/}"
    echo "${dirs//\/__path__/}"
  fi
}

d() {
  local dirs; dirs="$(project_dirs "$1")"
  local IFS=$':'
  local dir
  for dir in $dirs; do
    if [[ -d "$dir" ]]; then
      echo "$dir"
      break
    fi
  done
}

# do stuff with project
with_project() {
  local target="$1"
  [[ -e "$1" ]] || target="$(d "$1")"
  if [[ -e $target ]]; then
    echo -e "\033[0;34m${2} ${target}\033[00m"
    $2 "$target"
  else
    echo "unknown project"
    return 1
  fi
}

# cd to project
c() { with_project "$1" cd; }

# open project in editor
e() { with_project "${1:-.}" "${BACKGROUND_EDITOR} --"; }

# bash completion with with_project and functions using it
_with_project() {
  local CDPATH; CDPATH="$(project_dirs):{$CDPATH}"
  _cd
}

if shopt -q cdable_vars; then
  [[ -n "$BASH_COMPLETION" ]] && complete -v -F _with_project -o nospace c e with_project
else
  [[ -n "$BASH_COMPLETION" ]] && complete -F _with_project -o nospace c e with_project
fi

###############################################################################
# SETUP PS1

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

__prompt_vcs() {
  if [[ -z "$NOPROMPT" ]]; then
    git_ref() {
      ref=$(echo -e "$(__git_ps1)")
      if [ -z "$ref" ]; then return 1; fi
      echo "$ref"
    }

    svn_ref() {
      [ -d ".svn" ] || return 1
      ref=$(svn info | awk '/^URL/ { sub(".*/","",$0); r=$0 } /^Revision/ { sub("[^0-9]*","",$0); print $0 }')
      echo " [$ref]"
    }

    git_ref || svn_ref
  fi
}
ps1_vcs='$(__prompt_vcs)'

__prompt_ruby_version() {
  local ruby_version
  if type rvm-prompt >/dev/null 2>&1; then
    rvm-prompt v g
    return $?
  fi

  if type chruby_auto >/dev/null 2>&1; then
    chruby_auto
  fi

  if [[ -n "$RUBY_VERSION" ]]; then
    ruby_version="$RUBY_VERSION"
  elif [[ -n "$RUBY_ROOT" ]]; then
    ruby_version="$(basename "$RUBY_ROOT")"
  elif type ruby > /dev/null 2>&1; then
    ruby_version="$(ruby --disable-gems -e "puts defined?(RUBY_ENGINE_VERSION) ? \"#{RUBY_ENGINE}-#{RUBY_ENGINE_VERSION}\" : \"ruby-#{RUBY_VERSION}\"")"
  else
    ruby_version=''
  fi

  ruby_version="${ruby_version#ruby-}"
  echo "$ruby_version"
}
ps1_ruby=' \[\e[0;34m\]$(__prompt_ruby_version)\[\e[00m\]'

# Short PWD, if it's to long.
__prompt_short_pwd() {
  local FIXED_PWD="${PWD#"$HOME"}"
  if [ "${#FIXED_PWD}" -lt "${#PWD}" ]; then
    FIXED_PWD="~${FIXED_PWD}"
  else
    FIXED_PWD="$PWD"
  fi
  if [[ ${#FIXED_PWD} -gt $PWD_LENGTH ]]; then
    echo "${FIXED_PWD:0:$((4))}...${FIXED_PWD:$((${#PWD}-PWD_LENGTH+7)):$((PWD_LENGTH-7))}"
  else
    echo "$FIXED_PWD"
  fi
}
ps1_pwd='$(__prompt_short_pwd)'
ps1_exit_code='\[$([[ $? -eq 0 ]] && echo -e "\e[1;32m\]+" || echo -e "\e[1;31m\]-")\[\e[00m\] '

# Building $PS1.
if [[ -n "$ps1_user" ]] && [[ -n "$ps1_host" ]]; then ps1_user="$ps1_user@"; fi
PS1="${ps1_exit_code}${ps1_user}${ps1_host}"
[[ -n "$PS1" ]] && PS1="$PS1\[\e[00m\]:"
export PS1="${PS1}${ps1_pwd}${ps1_vcs}${ps1_ruby} \$ "
