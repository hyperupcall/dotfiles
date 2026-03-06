#!/usr/bin/env perl
use strict;
use warnings;
use 5.40.0;

use File::HomeDir;

my $minecraft_common_dir = File::HomeDir::my_home . "/.dotfiles/.home/Documents/Games/Minecraft_Common_Data";
if (! -f $minecraft_common_dir) {
	die "Expected directory to exist: \"$minecraft_common_dir\"";
}

#	local -a minecraft_dirs=(
#		~/.minecraft
#		"$XDG_DATA_HOME"/multimc/instances/*/.minecraft
#	)

#	for mc_dir in "${minecraft_dirs[@]}"; do
#		if [ ! -d "$mc_dir" ]; then
#			continue
#		fi

#		core.print_info "Processing $mc_dir"

#		# Sync Common Files
#		# files=(optionsLC.txt optionsof.txt optionsshaders.txt options.txt servers.dat servers.dat_old)
#		# files=(servers.dat)

#		# Sync Common Directories
#		local subdir=
#		for subdir in resourcepacks shaderpacks saves screenshots; do
#			mkdir -p "$mc_common_data/$subdir"

#			printf '%s\n' "  -> Symlinking ./$subdir"
#			if [ -L "$mc_dir/$subdir" ]; then
#				ln -sfT "$mc_common_data/$subdir" "$mc_dir/$subdir"
#			else
#				rmdir "$mc_dir/$subdir"
#				ln -sfT "$mc_common_data/$subdir" "$mc_dir/$subdir"
#			fi
#		done; unset -v subdir
#	done
#}
