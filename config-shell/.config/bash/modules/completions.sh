# bash_completion (also sources $XDG_CONFIG_HOME/bash/bash_completions (as per env variable))
# even though we `source /etc/profile` at beginnning of script, this is still needed since we now
# only have BASH_COMPLETION_USER_DIR and BASH_COMPLETION_USER_FILE set
[ -f /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion
