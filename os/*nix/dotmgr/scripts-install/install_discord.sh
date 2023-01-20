# shellcheck shell=bash

# Name:
# Install Discord

{
	if util.is_cmd 'apt'; then (
		util.cd_temp
		util.req -o './discord.deb' 'https://discord.com/api/download?platform=linux&format=deb'
	) else (
		util.cd_temp
		util.req -o './discord.tar.gz' 'https://discord.com/api/download?platform=linux&format=tar.gz'
		tar xf './discord.tar.gz'
	) fi
}
