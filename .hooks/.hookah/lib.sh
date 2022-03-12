# shellcheck shell=bash
# Version: 0.1.2

# @file lib.sh
# @description Function library for Git hooks configured with Hookah

# @description initiates the environment, sets up stacktrace printing on 'ERR' trap,
# and sets the directory to the root of the Git repository
# @noargs
hookah.init() {
	if [ -z "$BASH_VERSION" ]; then
		printf '%s\n' "Hookah: Error: This script is only compatible with Bash. Exiting" >&2
		exit 1
	fi

	set -Eeo pipefail
	shopt -s dotglob extglob globasciiranges globstar lastpipe shift_verbose
	export LANG='C' LC_CTYPE='C' LC_NUMERIC='C' LC_TIME='C' LC_COLLATE='C' LC_MONETARY='C' LC_MESSAGES='C' \
		LC_PAPER='C' LC_NAME='C' LC_ADDRESS='C' LC_TELEPHONE='C' LC_MEASUREMENT='C' LC_IDENTIFICATION='C' LC_ALL='C'
	trap '__hookah_trap_err' 'ERR'

	while [ ! -d '.git' ] && [ "$PWD" != / ]; do
		if ! cd ..; then
			printf '%s\n' "Hookah: Error: Failed to 'cd' to nearest Git repository. Exiting" >&2
			return 1
		fi
	done
	if [ "$PWD" = / ]; then
		printf '%s\n' "Hookah: Error: Failed to 'cd' to nearest Git repository. Exiting" >&2
		return 1
	fi

	# Prevent bugs like:
	# - https://github.com/typicode/husky/issues/627
	# - https://github.com/yarnpkg/yarn/issues/743
	# - https://github.com/typicode/husky/issues/850
	# - https://github.com/yarnpkg/yarn/issues/2998
	if command -v 'winpty' &>/dev/null && [ -t 1 ]; then
		exec </dev/tty

	fi

	# TODO print large
	printf '%s\n' "Hookah: Running ${BASH_SOURCE[1]##*/}"
}

# @description Prints a command before running it
hookah.run() {
	printf '%s\n' "Hookah: Running command: '$*'"
	"$@"
}

# @description Prints a command before running it. If the command fails, print a message,
# but do not abort execution
hookah.run_allow_fail() {
	if ! hookah.run "$@"; then
		printf '%s\n' "Hookah: Command failed"
	fi
}

# @description Tests if currently in CI
# @exitcode 0 If in CI
# @exitcode 1 If not in CI
# @set REPLY Current provider for CI
hookah.is_ci() {
	unset -v REPLY; REPLY=

	# See https://github.com/watson/ci-info/blob/master/vendors.json
	# node -e $'for (const ci of JSON.parse(require("fs").readFileSync("vendors.json"))) { console.info(`\\telif [[ -v \047${ci.env}\047 ]]; then\\n\\t\\tREPLY=\047${ci.name}\047`) }'

	if [[ -v 'APPVEYOR' ]]; then
		REPLY='AppVeyor'
	elif [[ -v 'SYSTEM_TEAMFOUNDATIONCOLLECTIONURI' ]]; then
		REPLY='Azure Pipelines'
	elif [[ -v 'AC_APPCIRCLE' ]]; then
		REPLY='Appcircle'
	elif [[ -v 'bamboo_planKey' ]]; then
		REPLY='Bamboo'
	elif [[ -v 'BITBUCKET_COMMIT' ]]; then
		REPLY='Bitbucket Pipelines'
	elif [[ -v 'BITRISE_IO' ]]; then
		REPLY='Bitrise'
	elif [[ -v 'BUDDY_WORKSPACE_ID' ]]; then
		REPLY='Buddy'
	elif [[ -v 'BUILDKITE' ]]; then
		REPLY='Buildkite'
	elif [[ -v 'CIRCLECI' ]]; then
		REPLY='CircleCI'
	elif [[ -v 'CIRRUS_CI' ]]; then
		REPLY='Cirrus CI'
	elif [[ -v 'CODEBUILD_BUILD_ARN' ]]; then
		REPLY='AWS CodeBuild'
	elif [[ -v 'CF_BUILD_ID' ]]; then
		REPLY='Codefresh'
	elif [[ -v '[object Object]' ]]; then
		REPLY='Codeship'
	elif [[ -v 'DRONE' ]]; then
		REPLY='Drone'
	elif [[ -v 'DSARI' ]]; then
		REPLY='dsari'
	elif [[ -v 'EAS_BUILD' ]]; then
		REPLY='Expo Application Services'
	elif [[ -v 'GITHUB_ACTIONS' ]]; then
		REPLY='GitHub Actions'
	elif [[ -v 'GITLAB_CI' ]]; then
		REPLY='GitLab CI'
	elif [[ -v 'GO_PIPELINE_LABEL' ]]; then
		REPLY='GoCD'
	elif [[ -v 'LAYERCI' ]]; then
		REPLY='LayerCI'
	elif [[ -v 'HUDSON_URL' ]]; then
		REPLY='Hudson'
	elif [[ -v 'JENKINS_URL,BUILD_ID' ]]; then
		REPLY='Jenkins'
	elif [[ -v 'MAGNUM' ]]; then
		REPLY='Magnum CI'
	elif [[ -v 'NETLIFY' ]]; then
		REPLY='Netlify CI'
	elif [[ -v 'NEVERCODE' ]]; then
		REPLY='Nevercode'
	elif [[ -v 'RENDER' ]]; then
		REPLY='Render'
	elif [[ -v 'SAILCI' ]]; then
		REPLY='Sail CI'
	elif [[ -v 'SEMAPHORE' ]]; then
		REPLY='Semaphore'
	elif [[ -v 'SCREWDRIVER' ]]; then
		REPLY='Screwdriver'
	elif [[ -v 'SHIPPABLE' ]]; then
		REPLY='Shippable'
	elif [[ -v 'TDDIUM' ]]; then
		REPLY='Solano CI'
	elif [[ -v 'STRIDER' ]]; then
		REPLY='Strider CD'
	elif [[ -v 'TASK_ID,RUN_ID' ]]; then
		REPLY='TaskCluster'
	elif [[ -v 'TEAMCITY_VERSION' ]]; then
		REPLY='TeamCity'
	elif [[ -v 'TRAVIS' ]]; then
		REPLY='Travis CI'
	elif [[ -v 'NOW_BUILDER' ]]; then
		REPLY='Vercel'
	elif [[ -v 'APPCENTER_BUILD_ID' ]]; then
		REPLY='Visual Studio App Center'
	else
		return 1
	fi
}

# @description Test whether color should be outputed
# @exitcode 0 if should print color
# @exitcode 1 if should not print color
# @internal
__hookah_is_color() {
	if [[ -v NO_COLOR || $TERM == dumb ]]; then
		return 1
	else
		return 0
	fi
}

# @internal
__hookah_internal_error() {
	printf '%s\n' "Internal Error: $1" >&2
}

# @internal
__hookah_trap_err() {
	local error_code=$?

	# TODO
	__hookah_internal_error "Your hook did not exit successfully"
	__hookah_print_stacktrace

	exit $error_code
} >&2

# TODO: fix (broken)
# @internal
__hookah_print_stacktrace() {
	if __hookah_is_color; then
		printf '\033[4m%s\033[0m\n' 'Stacktrace:'
	else
		printf '%s\n' 'Stacktrace:'
	fi

	local i=
	for ((i=0; i<${#FUNCNAME[@]}-1; i++)); do
		local __bash_source=${BASH_SOURCE[$i]}; __bash_source="${__bash_source##*/}"
		printf '%s\n' "  in ${FUNCNAME[$i]} ($__bash_source:${BASH_LINENO[$i-1]})"
	done; unset -v i __bash_source
} >&2
