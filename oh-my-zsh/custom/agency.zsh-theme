# oh-my-zsh Bureau Theme

### NVM

ZSH_THEME_NVM_PROMPT_PREFIX="%B⬡%b "
ZSH_THEME_NVM_PROMPT_SUFFIX=""

### Git [±master ▾●]
#to chose colors use 'spectrum_ls'
GREEN="154"
YELLOW="142"
RED="196"
BLUE="033"
WHITE="015"
GRAY="246"
GRAY_2="240"
PURPLE="013"
MAGENTA="005"
CYAN="037"

ZSH_THEME_GIT_PROMPT_PREFIX="[%{$FG[$GRAY]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}]"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$FG[$PURPLE]%}❱%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$FG[$MAGENTA]%}❱%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$FG[$GREEN]%}❱%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$FG[$CYAN]%}❱%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$FG[$RED]%}❱%{$reset_color%}"

bureau_git_branch () {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

bureau_git_status () {
  _INDEX=$(command git status --porcelain -b 2> /dev/null)
  _STATUS=""
  if $(echo "$_INDEX" | grep '^[AMRD]. ' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi
  if $(echo "$_INDEX" | grep '^.[MTD] ' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi
  if $(echo "$_INDEX" | command grep -E '^\?\? ' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi
  if $(echo "$_INDEX" | grep '^UU ' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi
  if $(echo "$_INDEX" | grep '^## .*ahead' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
  if $(echo "$_INDEX" | grep '^## .*behind' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_BEHIND"
  fi
  if $(echo "$_INDEX" | grep '^## .*diverged' &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_DIVERGED"
  fi

  echo $_STATUS
}

bureau_git_prompt () {
  local _branch=$(bureau_git_branch)
  local _status=$(bureau_git_status)
  local _result=""
  if [[ "${_branch}x" != "x" ]]; then
    _result="$ZSH_THEME_GIT_PROMPT_PREFIX$_branch"
    if [[ "${_status}x" != "x" ]]; then
      _result="$_result$_status"
    fi
    _result="$_result$ZSH_THEME_GIT_PROMPT_SUFFIX "
  fi
  echo $_result
}

_PATH="%{$FG[$GRAY_2]%}%~%{$reset_color%}"

_name=$(uname -s)

if [ "$_name" = "Darwin" ]; then
  _LIBERTY="%{$FG[$BLUE]%}☖"
elif [ "$_name" = "Linux" ]; then
  _LIBERTY="%{$FG[$BLUE]%}☗"
fi
_LIBERTY="$_LIBERTY%{$reset_color%}"


get_space () {
  local STR=$1$2
  local zero='%([BSUbfksu]|([FB]|){*})'
  local LENGTH=${#${(S%%)STR//$~zero/}} 
  local SPACES=""
  (( LENGTH = ${COLUMNS} - $LENGTH - 1))
  
  for i in {0..$LENGTH}
    do
      SPACES="$SPACES "
    done

  echo $SPACES
}

_1LEFT="$_PATH"
_1RIGHT=""

bureau_precmd () {
  _1SPACES=`get_space $_1LEFT $_1RIGHT`
  print 
  print -rP "$_1LEFT$_1SPACES$_1RIGHT"
}

setopt prompt_subst
PROMPT='$_LIBERTY $(bureau_git_prompt)'
RPROMPT='$(nvm_prompt_info)'

autoload -U add-zsh-hook
add-zsh-hook precmd bureau_precmd
