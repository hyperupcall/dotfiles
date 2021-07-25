# bpm.fish
if type -p bpm
	source (bpm init fish | psub)
end

# direnv.fish
if type -p direnv
	direnv hook fish | source
end

# zoxide.fish
if type -p zoxide
	zoxide init fish | source
end

