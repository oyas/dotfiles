#
# for Mac
#

# color
#export TERM=xterm-color
PS1="\[\033[36m\]\h:\W \u\$\[\033[0m\] "
# ls color
export LSCOLORS=dxfxcxdxbxegedabagacad

# alias
alias ls='ls -G'
alias l='ls -F'
alias ll='ls -hl'
alias la='ls -la'
alias vi='vim'

# git completion
source ~/.git-completion.bash
