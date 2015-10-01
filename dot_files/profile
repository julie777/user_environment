# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1) if ~/.bash_profile or ~/.bash_login exists.
# See /usr/share/doc/bash/examples/startup-files for examples.
# The files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
# umask 022

echo "Running .profile for login shell"

# if running bash
if [ -n "$BASH_VERSION" ]; then
    echo "Bash version: ${BASH_VERSION}"
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# TODO: the prompt doesn't need to be here
# setup the prompt
export SUDO_PS1="\[\e[0;32m\]\u\[\e[m\]\[\e[1;33m\]@\[\e[m\]\[\e[1;32m\]\h\[\e[m\]\[\e[0;33m\]:\[\e[m\]\[\e[1;37m\]\w\[\e[m\] \$(git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/{\1} /')\[\e[0;35m\]$ \[\e[m\]"
export PS1="\[\e[0;32m\]\u\[\e[m\]\[\e[1;33m\]@\[\e[m\]\[\e[1;32m\]\h\[\e[m\]\[\e[0;33m\]:\[\e[m\]\[\e[1;37m\]\w\[\e[m\] \[\e[1;33m\]\$(git branch 2> /dev/null | grep -e '\* ' | sed 's/^..\(.*\)/{\1} /')\[\e[0;35m\]$ \[\e[m\]"
