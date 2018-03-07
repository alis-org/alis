[[ -n "${key[Home]}"     ]]  && bindkey  "${key[Home]}"     beginning-of-line
[[ -n "${key[End]}"      ]]  && bindkey  "${key[End]}"      end-of-line
[[ -n "${key[Insert]}"   ]]  && bindkey  "${key[Insert]}"   overwrite-mode
[[ -n "${key[Delete]}"   ]]  && bindkey  "${key[Delete]}"   delete-char
[[ -n "${key[Up]}"       ]]  && bindkey  "${key[Up]}"       up-line-or-history
[[ -n "${key[Down]}"     ]]  && bindkey  "${key[Down]}"     down-line-or-history
[[ -n "${key[Left]}"     ]]  && bindkey  "${key[Left]}"     backward-char
[[ -n "${key[Right]}"    ]]  && bindkey  "${key[Right]}"    forward-char
[[ -n "${key[PageUp]}"   ]]  && bindkey  "${key[PageUp]}"   beginning-of-buffer-or-history
[[ -n "${key[PageDown]}" ]]  && bindkey  "${key[PageDown]}" end-of-buffer-or-history


# just type '...' to get '../..'
rationalise-dot() {
local MATCH
if [[ $LBUFFER =~ '(^|/| |	|'$'\n''|\||;|&)\.\.$' ]]; then
  LBUFFER+=/
  zle self-insert
  zle self-insert
else
  zle self-insert
fi
}
zle -N rationalise-dot
bindkey . rationalise-dot
## without this, typing a . aborts incremental history search
bindkey -M isearch . self-insert

## alert me if something failed
setopt printexitvalue

## Allow comments even in interactive shells
setopt interactivecomments

## Use a default width of 80 for manpages for more convenient reading
export MANWIDTH=${MANWIDTH:-80}

## Sourcing usefull scripts
if [ -e /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
        source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [ -e /usr/share/zsh/plugins/transfer/transfer.zsh ]; then
        source /usr/share/zsh/plugins/transfer/transfer.zsh
fi

if [ -e /usr/share/doc/pkgfile/command-not-found.zsh ]; then
        source /usr/share/doc/pkgfile/command-not-found.zsh
fi

if [ -e /usr/share/git/completion/git-prompt.zsh ]; then
        source /usr/share/git/completion/git-prompt.sh
        zstyle ':completion:*:*:git:*' script /usr/share/git/completion/git-completion.zsh
fi

if [ -f /usr/bin/grc ]; then
 alias gcc="grc --colour=auto gcc"
 alias irclog="grc --colour=auto irclog"
 alias log="grc --colour=auto log"
 alias netstat="grc --colour=auto netstat"
 alias ping="grc --colour=auto ping"
 alias proftpd="grc --colour=auto proftpd"
 alias traceroute="grc --colour=auto traceroute" 
fi

## Always renash
zstyle ':completion:*' rehash true

## changed completer settings
zstyle ':completion:*' completer _complete _correct _approximate
zstyle ':completion:*' expand prefix suffix

# less settings
export LESSOPEN="| /usr/bin/src-hilite-lesspipe.sh %s"
export LESS=-R
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline

man() {
LESS_TERMCAP_md=$'\e[01;31m' \
LESS_TERMCAP_me=$'\e[0m' \
LESS_TERMCAP_se=$'\e[0m' \
LESS_TERMCAP_so=$'\e[01;44;33m' \
LESS_TERMCAP_ue=$'\e[0m' \
LESS_TERMCAP_us=$'\e[01;32m' \
command man "$@"
}

## Git prompt
setopt PROMPT_SUBST ; PS1='[%n@%m %c$(__git_ps1 " (%s)")]\$ '
## + for staged, * if unstaged.
GIT_PS1_SHOWDIRTYSTATE=true
## GIT_PS1_SHOWSTASHSTATE
GIT_PS1_SHOWSTASHSTATE=true
##% if there are untracked files.
GIT_PS1_SHOWUNTRACKEDFILES=true
##<,>,<> behind, ahead, or diverged from upstream
GIT_PS1_SHOWUPSTREAM=true

## Custom alias
alias vim="nvim"
alias vimdiff="nvim -d"

export MANPAGER="nvim -c 'set ft=man nomod nolist hlsearch incsearch' -"


