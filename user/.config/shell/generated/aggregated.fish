# basalt.fish
if type -p basalt
	basalt init fish | source
end

# direnv.fish
if type -p direnv
	direnv hook fish | source
end

# zoxide.fish
if type -p zoxide
	zoxide init fish | source
end
