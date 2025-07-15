#
# ~/.bashrc
#

# If not running interactively, don't do anything
fastfetch --config examples/13
eval "$(oh-my-posh init bash --config /usr/share/oh-my-posh/themes/negligible.omp.json)"

[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
