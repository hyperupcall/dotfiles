# bpm.fish
source (bpm init fish | psub)

# direnv.fish
if type -p direnv
	direnv hook fish | source
end

