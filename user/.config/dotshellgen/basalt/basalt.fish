if test -d "$HOME/repos/basalt/pkg/bin"
	basalt global init fish | source
else if test -d "$XDG_DATA_HOME/basalt/source/pkg/bin"
	basalt global init fish | source
end
