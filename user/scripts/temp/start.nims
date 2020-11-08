#!/usr/bin/env nim

const removes = [
	".lesshst",
	".nv",
	".dbshell",
	".bash_history",
	"yarn.lock",
	"node_modules",
	".sonarlint",
	".m2"
]

const creates = [
	".history",
	"data/go-path",
	"data/gnupg"
]

cosnt check = [
	".swp"
]

const links = [
	"Docs/programming/repos repos",
	"Docs/programming/projects projects",
	"Docs/programming/workspaces workspaces"
]

exec cargo install broot
exec cargo install just
exec cargo install starship
exec cargo install git-delta
exec yarn config set prefix "$XDG_DATA_HOME/yarn"
exec pnpm i -g diff-so-fancy

#lstopo
