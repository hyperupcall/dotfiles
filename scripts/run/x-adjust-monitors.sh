#!/bin/bash -eu

# ------------------- helper functions ------------------- #
hasColor()
{
	test -t 1 && command -v tput > /dev/null \
		&& test -n "$(tput colors)" && test "$(tput colors)" -ge 8
}

printInfo()
{
	if hasColor; then
		printf "\033[0;94m"
		# shellcheck disable=SC2059
		printf "$@"
		printf "\033[0m"
	else
		# shellcheck disable=SC2059
		printf "$@"
	fi
}

printError()
{
	if hasColor; then
		printf "\033[0;31m"
		# shellcheck disable=SC2059
		printf "$@"
		printf "\033[0m"
	else
		# shellcheck disable=SC2059
		printf "$@"
	fi
}

# ------------------- display functions ------------------ #
function primary()
{
	xrandr \
		--output DP-5 --auto \
		--output DP-3 --below DP-3 --auto \
		--output DP-3 --left-of HDMI-0 --auto \
		--output DVI-D-0 --right-of HDMI-0 --auto
}

# ------------------------- main ------------------------- #
stations=("primary" "secondary")

chosenStation="${chosenStation:-""}"
declare -l chosenStation

select station in "${stations[@]}"; do
	# strip whitespace
	REPLY=$(echo "$REPLY" | xargs)

	chosenStation="$station"
	break
done

test -z "$station" && {
	printError "Your choice was invalid. Please select a valid option.\n"
	exit 1
}

printInfo "Processing for '%s'\n" "$chosenStation"
case "$chosenStation" in
	"primary")
		primary
		;;
	"secondary")
		printError "secondary not supported\n"
		exit 1
		;;
	*)
		printError "Your choice '$chosenStation' did not match any existing options.\n"
		exit 1
		;;
esac
