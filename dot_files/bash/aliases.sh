#!/bin/bash

# TODO: move to color.sh ??
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)"           "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# some more ls aliases
alias l='ls --group-directories-first'
alias ll='ls -lFh --group-directories-first'
alias lla='ls -alFh --group-directories-first'
alias lg='ls -AgGh --group-directories-first'
alias lt='ls -tAlFh --group-directories-first'
alias la='ls -A --group-directories-first'
#alias l='ls -CF'
# -d  directory with no contents, useful for pattern match:
alias lsd='ls -d --group-directories-first'

alias h="history"
alias m="less"
alias df="df -x tmpfs -x devtmpfs -h --output=used,avail,target"
alias dfh="df -h ."

alias nose=nosetests
alias nosed="nosetests --logging-clear-handlers --logging-level=DEBUG"
alias g=git
alias wing=wing5.0
alias workoff='deactivate'

# naviation
alias logs='cd ~/vmshare/accesslogs'
alias cms="cd /opt/move/share/versions/cms && . pyenv/bin/activate"
alias mgt="cd /opt/move/cmsmgt && . pyenv/bin/activate"
alias cdw='cd ${VIRTUAL_ENV}'

