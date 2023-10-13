#
# ~/.bashrc (originally taken from Manjaro default)
#


#### Basic environment variables ####

if which nvim &>/dev/null; then
  export EDITOR="nvim"
  export VISUAL="nvim"
else
  export EDITOR="vim"
  export VISUAL="vim"
fi

# Ensure locals are in the PATH
export PATH="~/.local/bin:/usr/local/bin:$PATH"

# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=500

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace


#### Stop non-interactive sessions here ####
[[ $- != *i* ]] && return


#### Useful functions ####

function colors() {
  local fgc bgc vals seq0

  printf "Color escapes are %s\n" '\e[${value};...;${value}m'
  printf "Values 30..37 are \e[33mforeground colors\e[m\n"
  printf "Values 40..47 are \e[43mbackground colors\e[m\n"
  printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"

  # foreground colors
  for fgc in {30..37}; do
    # background colors
    for bgc in {40..47}; do
      fgc=${fgc#37} # white
      bgc=${bgc#40} # black

      vals="${fgc:+$fgc;}${bgc}"
      vals=${vals%%;}

      seq0="${vals:+\e[${vals}m}"
      printf "  %-9s" "${seq0:-(default)}"
      printf " ${seq0}TEXT\e[m"
      printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m"
    done
    echo; echo
  done
}


#### Prompt functions ####

function prompt_symbol() {
  if [ ${EUID} -eq 0 ]; then
    echo '#'
  else
    echo '$'
  fi
}

function prompt_err_code() {
  if [ $PROMPT_ERR -ne 0 ]; then
    printf " $PROMPT_ERR "
  fi
}

# get current branch in git repo
function prompt_git() {
  BRANCH="$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')"
  if [ ! "${BRANCH}" == "" ]
  then
    STAT="$(_prompt_git_dirty)"
    echo " (${BRANCH}${STAT})"
  else
    echo ""
  fi
}

# get current status of git repo
function _prompt_git_dirty {
  status=`git status 2>&1 | tee`
  dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
  untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
  ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
  newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
  renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
  deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
  bits=''
  if [ "${ahead}" == "0" ]; then
    bits="*${bits}"
  fi
  if [ "${newfile}" == "0" ]; then
    bits="+${bits}"
  fi
  if [ "${untracked}" == "0" ]; then
    bits="?${bits}"
  fi
  if [ "${deleted}" == "0" ]; then
    bits="x${bits}"
  fi
  if [ "${dirty}" == "0" ]; then
    bits="~${bits}"
  fi
  if [ "${renamed}" == "0" ]; then
    bits=">${bits}"
  fi
  if [ ! "${bits}" == "" ]; then
    echo " ${bits}"
  else
    echo ""
  fi
}


[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Store previous error for displaying on prompt
PROMPT_COMMAND='PROMPT_ERR=$?'

# Change the window title of X terminals
case ${TERM} in
  xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
    cmd='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
    PROMPT_COMMAND="$PROMPT_COMMAND; $cmd"
    ;;
  screen*)
    cmd='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
    PROMPT_COMMAND="$PROMPT_COMMAND; $cmd"
    ;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
  && type -P dircolors >/dev/null \
  && match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
  # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
  if type -P dircolors >/dev/null ; then
    if [[ -f ~/.dir_colors ]] ; then
      eval $(dircolors -b ~/.dir_colors)
    elif [[ -f /etc/DIR_COLORS ]] ; then
      eval $(dircolors -b /etc/DIR_COLORS)
    fi
  fi


  # Prompt formatting commands
  rst='\[\033[00m\]'

  # Change main color when running with root permissions
  if [ ${EUID} -eq 0 ]; then
    main_clr='\[\033[31m\]'
  else
    main_clr='\[\033[32m\]'
  fi

  main_clr="$rst$main_clr"
  dir_clr='\[\033[37m\]'
  dir_clr="$rst$dir_clr"
  err_clr='\[\033[31m\]'
  err_clr="$rst$err_clr"
  git_clr='\[\033[36m\]'
  git_clr="$rst$git_clr"

  # PS1="$clr" '[\u@\h\[\033[01;37m\] \W\[\033[01;30m\]$(prompt_git)\[\033[01;31m\]\[\033[01;32m\]]\[\033[01;31m\]$(prompt_err_code)\[\033[01;32m\]$(prompt_symbol)\[\033[00m\] '

  PS1="${main_clr}[\\u@\\h ${dir_clr}\\W${git_clr}\$(prompt_git)${main_clr}]${err_clr}\$(prompt_err_code)${main_clr}\$(prompt_symbol) $rst"

  unset rst main_clr dir_clr err_clr git_clr

  alias ls='ls --color=auto'
  alias grep='grep --colour=auto'
  alias egrep='egrep --colour=auto'
  alias fgrep='fgrep --colour=auto'
else
  PS1='[\u@\h \w$(prompt_git)]$(prompt_err_code)$(prompt_symbol) '
fi

unset use_color safe_term match_lhs sh



# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.
shopt -s checkwinsize

shopt -s expand_aliases

# Enable history appending instead of overwriting
shopt -s histappend


#### Aliases ####

if which nvim &>/dev/null; then alias vim='nvim'; fi


