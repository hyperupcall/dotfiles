yarn() {
	yarn why
}

dep list --depth=? --reverse
- yarn why


# list first level of dependencies package

# of particular package in local project, list subdependencies
# --reverse
# --recursive
package_list_local() {
	npm view "$package" dependencies # json
}


# of particular package in global namespace, list subdependencies
# --reverse
# --recursive
package_global_list() {
	npm -g view "$package" dependencies # json
}

# of top level dependency tree in local project, list all packages
top_local_list() {
	:
}

# of top level dependency tree in global namespace, list all packages
top_global_list() {
	yarn global list
	npm -g list
}
