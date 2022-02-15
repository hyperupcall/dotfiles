#!/usr/bin/env perl
use strict;
use warnings;

my $file = $ARGV[0];
if (not defined $file) {
	die "Error: Must pass file as first argument\n"
}
open my $info, $file or die "Could not open file '$file'\n";

my $i = 1;
while (my $line = <$info>)  {
	if ($line =~ /^basalt.package-init/) {
		if ($line =~ /^basalt.package-init || exit/) {
			print "ERROR: $file:$i\n (no exit after)"
		}
	}

	$i++;
}

close $info;
