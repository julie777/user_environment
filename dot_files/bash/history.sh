#!/bin/bash

## history.sh ##

# get history out of home dir
HISTDIR=${HOME}/.history
[ -d $HISTDIR ] || mkdir --mode=0700 $HISTDIR
[ -d $HISTDIR ] && chmod 0700 $HISTDIR

# each shell has its own history file
HISTFILE=$HISTDIR/history.$$

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignorespace:ignoredups:erasedups

# keep enough history to make it worthwhile
HISTSIZE=100000
HISTFILESIZE=100000

shopt -s histappend
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "

# clean out history more than 30 days old
echo "Removing old history files."
find ${HISTDIR} -type f -mtime +30 -print -delete

# load the previous history
history -r $(ls -t ${HISTDIR} | head -n 5)


# Notes:

# To quote the manpage: If set, the value is executed as a command
# prior to issuing each primary prompt.
# export PROMPT_COMMAND='history -a'

# Save and reload the history after each command finishes
# export PROMPT_COMMAND="history -a;"$PROMPT
# commands
#  history -a   # append current history to file
#  history -c   # clear history list
#  history -r; $PROMPT_COMMAND" #read the history file and add commands to current history

# So every time my command has finished, it appends the unwritten history
# item to ~/.bash_history before displaying the prompt (only $PS1) again.
#
## close any old history file by zeroing HISTFILESIZE
# HISTFILESIZE=0
#
# history/* | sort | uniq -c |sort -n -r |less
#   or
# cut -f1-2 "-d " .history/* | sort | uniq -c |sort -n -r |less
#

