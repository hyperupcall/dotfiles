#!/usr/bin/env perl
use strict;
use warnings;

use File::Which;
use File::Basename qw(dirname);
use feature 'say';

my $script_dir = dirname(__FILE__);
my $config = do "$script_dir/../data/setup-private.pl" or die "Failed to load setup-private.pl: $!";
my $virtualbox_dir = $config->{_private_virtualbox_dir};

if (defined which('VBoxManage')) {
	`VBoxManage setproperty machinefolder "$virtualbox_dir"`;
} else {
	die "Must have command 'VBoxManage' installed";
}

if (grep(/^--help|-h$/, @ARGV)) {
	say 'Usage: ' . $0 . ' [-h|--help] [--unregister]';
	exit 0;
}

if (grep(/^--unregister$/, @ARGV)) {
	open(my $fh, '-|', 'VBoxManage list vms') or die $!;
	while (my $line = <$fh>) {
		if ($line =~ m/\"(.*?)\" \{(.*?)\}/) {
			my $name = $1;
			my $uuid = $2;
			say('Removing "' . $name . '"');
			`VBoxManage unregistervm $uuid`
		} else {
			die "Capture group failed on line: $line";
			exit 0;
		}
	}
	exit 0;
}

if (! -d $virtualbox_dir) {
	die 'Failed to find directory: ' . $virtualbox_dir;
}

opendir(my $dh, $virtualbox_dir) or die $!;
while (my $dirname = readdir($dh)) {
	next if ($dirname eq '.' || $dirname eq '..');

	# Is not a group.
	if (-f "$virtualbox_dir/$dirname/$dirname.vbox") {
		say "REGISTERING $virtualbox_dir/$dirname/$dirname.vbox";
		`VBoxManage registervm "$virtualbox_dir/$dirname/$dirname.vbox"`;
	} else {
		opendir(my $dh2, "$virtualbox_dir/$dirname") or dir $!;
		while (my $dirname2 = readdir($dh2)) {
			next if ($dirname2 eq '.' || $dirname2 eq '..');

			if (-f "$virtualbox_dir/$dirname/$dirname2/$dirname2.vbox") {
				say "REGISTERING $virtualbox_dir/$dirname/$dirname2/$dirname2.vbox";
				`VBoxManage registervm "$virtualbox_dir/$dirname/$dirname2/$dirname2.vbox"`;
			}
		}
	}
}
closedir($dh);
