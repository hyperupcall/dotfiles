# basalt.fish
# TODO: PATH ADD
basalt global init fish | source

# direnv.fish
if type -p direnv
	direnv hook fish | source
end

# zoxide.fish
if type -p zoxide
	zoxide init fish | source
end

