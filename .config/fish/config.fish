#set -g TERM xterm-256color

# ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# git alias
alias gs='git switch (git branch | peco | sed "s/.* //")'
alias g='git status'

# local bin
set -x PATH $HOME/.local/bin $PATH

# anyenv
set -x PATH $HOME/.anyenv/bin $PATH
anyenv init - fish | source

