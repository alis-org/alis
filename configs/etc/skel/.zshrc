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
alias mkdir='mkdir -p -v'
alias grep='grep --color=auto'
alias less='/usr/share/nvim/runtime/macros/less.sh'
alias  sudo="sudo -EHA"
export SYSTEMD_LESS=FRXMK
export SUDO_ASKPASS=/usr/bin/rosu
