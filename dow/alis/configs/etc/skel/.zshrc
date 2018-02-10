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

bindkey '\eq' push-line-or-edit

## alert me if something failed
setopt printexitvalue

## global aliases (for those who like them) ##

## Use a default width of 80 for manpages for more convenient reading
export MANWIDTH=${MANWIDTH:-80}

## Switching shell safely and efficiently? http://www.zsh.org/mla/workers/2001/msg02410.html
bash() {
    NO_SWITCH="yes" command bash "$@"
}
restart () {
    exec $SHELL $SHELL_ARGS "$@"
}

## Download a file and display it locally
uopen() {
    emulate -L zsh
    if ! [[ -n "$1" ]] ; then
        print "Usage: uopen \$URL/\$file">&2
        return 1
    else
        FILE=$1
        MIME=$(curl --head $FILE | \
               grep Content-Type | \
               cut -d ' ' -f 2 | \
               cut -d\; -f 1)
        MIME=${MIME%$'\r'}
        curl $FILE | see ${MIME}:-
    fi
}

## ctrl-s will no longer freeze the terminal.
stty erase "^?"

## you want to automatically use a bigger font on big terminals?
if [[ "$TERM" == "xterm" ]] && [[ "$LINES" -ge 50 ]] && [[ "$COLUMNS" -ge 100 ]] && [[ -z "$SSH_CONNECTION" ]] ; then
    large
fi

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh

source /usr/share/zsh/plugins/transfer/transfer.sh

if [ -e /usr/share/git/completion/git-prompt.sh ]; then
        source /usr/share/git/completion/git-prompt.sh
fi

source /usr/share/doc/pkgfile/command-not-found.zsh

## rehash
zstyle ':completion:*' rehash true

autoload -Uz compinit promptinit
compinit
promptinit

prompt walters

zstyle ':completion:*' menu select
