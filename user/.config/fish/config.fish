set -a fish_user_paths ~/.config/fish/functions

# franciscolourenco/done
set -U __done_min_cmd_duration 10000

# oh-my-fish/plugin-foreign-env
# source ~/.config/fish/functions/fenv.fish
# fenv source ~/.profile
# direnv hook fish | source

# !! and !$ in fish
function bind_bang
	switch (commandline -t)[-1]
		case "!"
				commandline -t $history[1]; commandline -f repaint
		case "*"
				commandline -i !
	end
end

function bind_dollar
	switch (commandline -t)[-1]
		case "!"
				commandline -t ""
				commandline -f history-token-search-backward
		case "*"
				commandline -i '$'
	end
end

function fish_user_key_bindings
	bind ! bind_bang
	bind '$' bind_dollar
end
