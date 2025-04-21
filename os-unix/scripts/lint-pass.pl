#!/usr/bin/env perl
use strict;
use warnings;

use File::Find;
use File::Spec;
use File::Basename;
use feature qw(say);

my $password_store_dir = '~/.dotfiles/.home/xdg_data_dir/password-store/';
my $total_passwords = 0;
my %property_counts = ();

my %find_args = (
	wanted => \&wanted,
	no_chdir => 1
);
find(\%find_args, glob($password_store_dir));
sub wanted {
	if ($File::Find::name =~ /.git/) {
		$File::Find::prune = 1;
	}

	if (! -f $File::Find::name) {
		return;
	}

	if ($File::Find::name !~ /\.gpg$/) {
		return;
	}

	$total_passwords += 1;

	my $len = length(File::Glob::bsd_glob($password_store_dir));
	my $pass_name = $File::Find::name;
	$pass_name =~ s/.gpg$//g;
	$pass_name = substr($pass_name, $len);

	# TODO: jobs/ should not be a website
	if ("$pass_name/" !~ /\.(?:
		com|edu|org|net|io|gov|dev|app|co|us|tv|ht|club|info|uk|me|de|ai|world|sh|click|
		works|is|ws|works|academy|to|lgbt|pizza|jobs|info|so|one|garden|xyz|ninja|link|
		dhl|exchange|it|fyi|ee|group|do|na|fm|host|tech|im|engineer|network|social|rest
	)\//x and $pass_name !~ /^jobs\//) {
		say(STDERR "Error: Filename must be a website: $pass_name");
	}

	my $pid = open(my $pipe_fh, "-|", "pass show $pass_name 2>&1");
	if (!defined $pid) {
		die "Failed to fork: $!";
	}
	my $pass_content = "";
	while (my $line = <$pipe_fh>) {
		$pass_content .= $line;
   }
   close($pipe_fh);
   waitpid($pid, 0);

	if ($pass_content =~ /gpg: no valid OpenPGP data found/) {
		my $symlink_content = "";
		open(my $fh, '<', $File::Find::name) or die "Failed to open file \"$File::Find::name\": $!";
		{
			local $/;
			$symlink_content = <$fh>;
		}
		close($fh) or die "Failed to close file \"$File::Find::name\": $1";
		my $maybe_file = File::Spec->catfile(File::Basename::dirname($File::Find::name), $symlink_content);
		if (-f $maybe_file) {
			say "File has invalid PGP data: \"$File::Find::name\"";
			say "But, file does have content: \"$symlink_content\"";
			print "Remove the invalid file, and replace it with a symlink? ";
			$| = 1;
			my $input = <STDIN>;
			chomp $input;
			if ($input =~ /^[yY]/) {
				unlink $File::Find::name or die "Failed to remove file: $!";
				symlink($symlink_content, $File::Find::name) or die "Failed to symlink file: $!";
			} else {
				say "Skipping...";
			}
		} else {
			say(STDERR "Error: No valid GPG data found: \"$File::Find::name\"");
			return;
		}
	}
	$pass_content =~ s/[ \t]+/ /g;

	my $filtered_pass_content = $pass_content =~ s/\s/+/gr;
	if ($filtered_pass_content eq '') {
		say(STDERR "Error: Should not be empty: $pass_name");
		return;
	}

	if ($pass_content !~ /^login:/m) {
		say(STDERR "Error: Should have the login field: $pass_name");
	}

	# Extra newline appended from run command.
	if ($pass_content =~ /\n\n\z/) {
		say(STDERR "Error: Should not have ending newline: $pass_name");
	}

	while ($pass_content =~ /\n(?<key>\N+?):[ \t]*(?<value>\N+)$/gm) {
		my $key = $+{key};
		my $value = $+{value};

		if ($key =~ /[ \t]/) {
			$key =~ s/[ \t]+/_INVALID_WHITESPACE_/g;
			say(STDERR "Error: Key should not have spaces: $pass_name");
		}

		if ($key =~ /^login$/) {
			$property_counts{'login'} += 1;
		} elsif ($key =~ /^email$/) {
			$property_counts{'email'} += 1;
		} elsif ($key =~ /^username$/) {
			$property_counts{'username'} += 1;
		} elsif ($key =~ /^comment$/) {
			$property_counts{'comment'} += 1;
		} elsif ($key =~ /^security_/) {
			$property_counts{'security_'} += 1;
		} elsif ($key =~ /^id/) {
			$property_counts{'id_'} += 1;
		} elsif ($key =~ /^pin/) {
			$property_counts{'pin_'} += 1;
		} elsif ($key =~ /^q_/) {
			$property_counts{'q_'} += 1;
		} else {
			say(STDERR "Error: Bad Key: ${pass_name}: $key");
			$property_counts{$key} += 1;
		}
	}

	# TODO: number with old email
	# TODO: login is second line
	# TODO: $+{Key} is [a-z][A-Z][0-9]_ only
}

say("Total passwords: $total_passwords");
my @keys = sort { $property_counts{$a} <=> $property_counts{$b} } keys(%property_counts);
my @vals = @property_counts{@keys};
foreach my $key (keys %property_counts) {
	say("$key: $property_counts{$key}");
}
