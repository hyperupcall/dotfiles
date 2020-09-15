set -a fish_user_paths ~/.config/fish/functions

# franciscolourenco/done
set -U __done_min_cmd_duration 10000

# oh-my-fish/plugin-foreign-env
source ~/.config/fish/functions/fenv.fish
fenv source ~/.profile

# gnomme-keyring-daemon
if test -n "$DESKTOP_SESSION"
    set (gnome-keyring-daemon --start | string split "=")
end
