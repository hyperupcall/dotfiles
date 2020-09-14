set -x PATH $PATH /sbin/

# franciscolourenco/done
set -U __done_min_cmd_duration 10000

# oh-my-fish/plugin-foreign-env
fenv source ~/.profile

# gnomme-keyring-daemon
if test -n "$DESKTOP_SESSION"
    set (gnome-keyring-daemon --start | string split "=")
end
