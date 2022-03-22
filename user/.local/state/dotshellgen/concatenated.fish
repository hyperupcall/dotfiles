# basalt.fish
set path=("$XDG_DATA_HOME/basalt/source/pkg/bin" $path)
basalt global init fish | source

# direnv.fish
if type -p direnv
	direnv hook fish | source
end

# zoxide.fish
if type -p zoxide
	zoxide init fish | source
end

