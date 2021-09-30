# basalt.fish
if test -d "$HOME/repos/basalt/pkg/bin"
	basalt global init fish | source
end

# direnv.fish
if type -p direnv
	direnv hook fish | source
end

# zoxide.fish
if type -p zoxide
	zoxide init fish | source
end

