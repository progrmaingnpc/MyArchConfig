#
# ~/.bashrc
#

# If not running interactively, don't do anything
fastfetch --config examples/13
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
