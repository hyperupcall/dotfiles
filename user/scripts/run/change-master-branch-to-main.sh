#!/bin/sh -eux

# code licensed under BSD 2-Clause "Simplified" License

# see `change-master-branch-to-main.sh --help` for usage
# see twitter thread for more details: https://twitter.com/EdwinKofler/status/1272729160620752898

site="github.com"
oldDefaultBranch="master"
newDefaultBranch="main"
bin="gh" # or set to 'hub'
user="${1:-""}"
repo="${2:-""}"

# ------------------- helper functions ------------------- #
showHelp() {
	echo "change-master-branch-to-main.sh"
	echo
	echo "Description:"
	echo "    Cross-platform shell script to change the 'master' branch to"
	echo "    'main' for the local and remote repository. Should work with"
	echo "    providers besides Github, but I haven't tested that"
	echo
	echo "Usage:"
	echo "    change-master-branch-to-main.sh [username] [repo name]"
	echo "        Rename the 'master' branch to 'main' both for the local"
	echo "        and remote repository with the specified variables. It"
	echo "        also sets the default branch to 'main' if the previous"
	echo "        default was 'master'"
	echo "    change-master-branch-to-main.sh"
	echo "        Same as above, but intelligently guesses (and ask user for"
	echo "        confirmation) the github user and repo names"
	echo
	echo "Requirements:"
	echo "    'jq' and 'gh' are optional dependencies and are only required"
	echo "    when trying to update the GitHub default branch"
	echo
	echo "Examples:"
	echo "    change-master-branch-to-main.sh eankeen deno-babel"
}

# get the GitHub username, if it wasn't already specified
askUser() {
	# return if user is already set (passed as arg)
	test ! -z "$user" && return

	# get github username and strip quotes
	url="$(git config --get remote.origin.url)"

	# if url looks like git@github.com:user/repo
	if [ "$(echo "$url" | cut -d'@' -f1)" = "git" ]; then
		user="$(echo "$url" | sed -E "s/(.*:)(.*)(\/.*)/\2/g")"
	else
		user="$(echo "$url" | sed -E "s/(.*$site\/)(.*)(\/.*)/\2/g")"
	fi

	printInfo "github username (default: %s): " "$user"
	read -r

	# trim whitespace
	REPLY="$(echo "$REPLY" | xargs)"

	user="${REPLY:-$user}"
	printInfo "input: $user\n\n"
}

# get the GitHub repository name, if it wasn't already specified
askRepo() {
	# return if repo is already set (passed as arg)
	test ! -z "$repo" && return

	url="$(git config --get remote.origin.url)"
	repo="$(basename -s .git "$url")"

	printInfo "github repository name (default: %s): " "$repo"
	read -r

	# trim whitespace
	REPLY="$(echo "$REPLY" | xargs)"

	repo="${REPLY:-$repo}"
	printInfo "input: $repo\n\n"
}

remoteMainExists() {
	git show-branch "refs/remotes/origin/$newDefaultBranch" >/dev/null 2>&1
}

remoteMasterExists() {
	git show-branch "refs/remotes/origin/$oldDefaultBranch" >/dev/null 2>&1
}

localMainExists() {
	git rev-parse --verify --quiet "refs/heads/$newDefaultBranch" >/dev/null
}

localMasterExists() {
	git rev-parse --verify --quiet "refs/heads/$oldDefaultBranch" >/dev/null
}

hasColor() {
	test -t 1 && command -v tput >/dev/null \
		                           && test -n "$(tput colors)" && test "$(tput colors)" -ge 8
}

hasBinAndJq() {
	command -v jq >/dev/null && command -v "$bin" >/dev/null
}

printInfo() {
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

# ------------------------- main ------------------------- #
test "${1:-""}" = "--help" && showHelp && exit

# ensure 'main' is the default locally
if ! localMainExists; then
	printInfo "renaming '$oldDefaultBranch' to '$newDefaultBranch' locally\n"
	git checkout $oldDefaultBranch
	git branch --move $oldDefaultBranch "$newDefaultBranch"
fi

# ensure 'main' is at remote
if ! remoteMainExists; then
	printInfo "setting '$newDefaultBranch' as default upstream branch\n"
	git checkout "$newDefaultBranch"
	git push --set-upstream origin "$newDefaultBranch"
fi

# remove local 'master' branch
if localMasterExists; then
	printInfo "renaming local $oldDefaultBranch branch\n"
	git branch --delete $oldDefaultBranch
fi

# ensure github default branch is 'main'
if hasBinAndJq; then
	askRepo
	askUser

	beforeNewbranch="$("$bin" api "repos/$user/$repo" -X GET | jq --raw-output ".default_branch")"

	# sets new default branch
	if test "$beforeNewbranch" = "$oldDefaultBranch"; then
		"$bin" api "repos/$user/$repo" -X PATCH -F default_branch="$newDefaultBranch"
	fi

	afterNewbranch="$("$bin" api "repos/$user/$repo" -X GET | jq --raw-output ".default_branch")"

	printInfo "default branch at $user/$repo was: '$beforeNewbranch'\n"
	printInfo "default branch at $user/$repo is now: '$afterNewbranch'\n"
fi

# remove remote 'master' branch
if remoteMasterExists; then
	printInfo "deleting remote $oldDefaultBranch branch\n"

	# if this fails, it may be due to forgetting
	# to reset the default branch to 'main' on github
	git push origin --delete $oldDefaultBranch

	test ! $? && printInfo "this probably errored since '$oldDefaultBranch' is still the 'default branch' on github" \
		&& printInfo "if you install \`gh\` and \`jq\` this will be done for you"
fi
