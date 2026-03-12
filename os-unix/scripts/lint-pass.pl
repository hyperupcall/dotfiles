#!/usr/bin/env perl
use strict;
use warnings;

use JSON;
use File::Find;
use File::Spec;
use File::Basename;
use feature qw(say);

# Read ignore list from config at startup
my $pass_store_dir = $ENV{PASSWORD_STORE_DIR};
my @ignore_list;

if ( !defined $pass_store_dir || $pass_store_dir eq '' ) {
   die "ERROR: \$PASSWORD_STORE_DIR environment variable is not set\n";
}

my $config_file = "$pass_store_dir/config.json";
if ( -f $config_file ) {
   open my $fh, '<', $config_file or die "Cannot open $config_file: $!\n";
   my $json_content = do { local $/; <$fh> };
   close $fh;

   my $config;
   eval { $config = decode_json($json_content); };
   if ($@) {
      die "ERROR: Failed to parse $config_file: $@\n";
   }

   if ( exists $config->{ignore_logins}
      && ref $config->{ignore_logins} eq 'ARRAY' )
   {
      @ignore_list = @{ $config->{ignore_logins} };
   }
   else {
      die "ERROR: $config_file does not contain an 'ignore_logins' array\n";
   }
}
else {
   die "ERROR: Config file not found at $config_file\n";
}

if ( grep { $_ eq '--fix-symlinks' } @ARGV ) {
   say "FILES WITH ASCII TEXT";

   File::Find::find(
      {
         wanted => sub {
            return unless -f $_ && /\.gpg$/;

            my $current_file_path = $File::Find::name;

            my $file_command_output = `file \"$current_file_path\" 2>&1`;

            if ( $file_command_output =~ /ASCII text/ ) {
               open my $fh, '<:encoding(UTF-8)', $current_file_path
                 or warn "Could not open '$current_file_path' for reading: $!\n"
                 and return;
               my $content = do { local $/; <$fh> };    # Slurp the file content
               close $fh;
               chomp $content;

               my $target_link_path;

               if ( $content =~ /^\// )
               {    # If content starts with '/' it's an absolute path
                  if ( $content eq $pass_store_dir ) {
                     $target_link_path = '.';
                  }
                  elsif ( $content =~ s/^\Q$pass_store_dir\/\E// ) {
                     $target_link_path = $content;
                  }
                  else {
                     warn
"Content '$content' is an absolute path but not within or equal to PASSWORD_STORE_DIR '$pass_store_dir'. Skipping '$current_file_path'.\n";
                     return
                       ; # Skip this file as its target is outside the expected store
                  }
               }
               else {
                  $target_link_path = $content;
               }

               say "removing $current_file_path";
               print
"Remove $current_file_path for symlink to $target_link_path? [y/n]? ";
               my $user_input = <STDIN>;
               chomp $user_input;

               if ( lc $user_input eq 'y' ) {
                  if ( unlink $current_file_path ) {
                     if ( symlink $target_link_path, $current_file_path ) {
                        say
"Symlink created at $current_file_path, to $target_link_path";
                     }
                     else {
                        warn
"Failed to create symlink from '$current_file_path' to '$target_link_path': $!\n";
                     }
                  }
                  else {
                     warn "Failed to remove '$current_file_path': $!\n";
                  }
               }
            }
         },
         no_chdir => 1,
      },
      $pass_store_dir
   );
   exit 0;
}

my $password_store_dir = '~/.dotfiles/.home/xdg_data_dir/password-store/';
my $total_passwords    = 0;
my %property_counts    = ();
my %email_counts;

my %find_args = (
   wanted   => \&wanted,
   no_chdir => 1
);
find( \%find_args, glob($password_store_dir) );

sub wanted {
   if ( $File::Find::name =~ /.git/ ) {
      $File::Find::prune = 1;
   }

   if ( !-f $File::Find::name ) {
      return;
   }

   if ( $File::Find::name !~ /\.gpg$/ ) {
      return;
   }

   $total_passwords += 1;

   my $len       = length( File::Glob::bsd_glob($password_store_dir) );
   my $pass_name = $File::Find::name;
   $pass_name =~ s/.gpg$//g;
   $pass_name = substr( $pass_name, $len );

   my $pid = open( my $pipe_fh, "-|", "pass show $pass_name 2>&1" );
   if ( !defined $pid ) {
      die "Failed to fork: $!";
   }
   my $pass_content = "";
   while ( my $line = <$pipe_fh> ) {
      $pass_content .= $line;
   }
   close($pipe_fh);
   waitpid( $pid, 0 );

   if ( $pass_content =~ /gpg: decryption failed: No secret key/ ) {
      say "No secret key found for file: \"$File::Find::name\"";
      return;
   }

   if ( $pass_content =~ /gpg: no valid OpenPGP data found/ ) {
      my $symlink_content = "";
      open( my $fh, '<', $File::Find::name )
        or die "Failed to open file \"$File::Find::name\": $!";
      {
         local $/;
         $symlink_content = <$fh>;
      }
      close($fh) or die "Failed to close file \"$File::Find::name\": $1";
      my $maybe_file =
        File::Spec->catfile( File::Basename::dirname($File::Find::name),
         $symlink_content );
      if ( -f $maybe_file ) {
         say "File \"$File::Find::name\" is supposed to be a symlink to \"$symlink_content\". Replacing.";
         unlink $File::Find::name or die "Failed to remove file: $!";
         symlink( $symlink_content, $File::Find::name )
            or die "Failed to symlink file: $!";

      }
      else {
         say( STDERR "No valid GPG data found: \"$File::Find::name\"" );
         return;
      }
   }

   $pass_content =~ s/[ \t]+/ /g;

   my $filtered_pass_content = $pass_content =~ s/\s/+/gr;
   if ( $filtered_pass_content eq '' ) {
      say( STDERR "Should not be empty: $pass_name" );
      return;
   }

   if ( $pass_name =~ /old\// ) {
      return;
   }

   if ( $pass_content !~ /^login:/m ) {
      if ( !grep( /^$pass_name$/, @ignore_list ) ) {
         say( STDERR "Should have the \"login\" field: $pass_name" );
      }

      my @lines = split( /\n/, $pass_content );
      if ( @lines >= 2 && $lines[1] !~ /^login:/ ) {
     		say( STDERR "The \"login\" field must be on the second line: $pass_name" );
      }
   }

   # Extra newline appended from run command.
   if ( $pass_content =~ /\n\n\z/ ) {
      say( STDERR "Should not have ending newline: $pass_name" );
   }

   while ( $pass_content =~ /\n(?<key>\N+?):[ \t]*(?<value>\N+)$/gm ) {
      my $key   = $+{key};
      my $value = $+{value};

      if ( $key =~ /[ \t]/ ) {
         $key =~ s/[ \t]+/_INVALID_WHITESPACE_/g;
         say( STDERR "Field identifier should not have spaces: $pass_name" );
      }

      if ( $key =~ /^login/ ) {
         $property_counts{'login'} += 1;
      }
      elsif ( $key =~ /^email$/ ) {
         $property_counts{'email'} += 1;
         $email_counts{$value} += 1;
      }
      elsif ( $key =~ /^username$/ ) {
         $property_counts{'username'} += 1;
      }
      elsif ( $key =~ /^comment$/ ) {
         $property_counts{'comment'} += 1;
      }
      elsif ( $key =~ /^password_/ ) {
         $property_counts{'password_'} += 1;
      }
      elsif ( $key =~ /^(?:secret_|password_)/ ) {
         $property_counts{'secret_|password_'} += 1;
      }
      elsif ( $key =~ /^id/ ) {
         $property_counts{'id_'} += 1;
      }
      elsif ( $key =~ /^pin/ ) {
         $property_counts{'pin_'} += 1;
      }
      elsif ( $key =~ /^q_/ ) {
         $property_counts{'q_'} += 1;
      }
      elsif ( $key =~ /^confidential_fields/ ) {
         $property_counts{'confidential_fields'} += 1;
      }
      else {
         say( STDERR "Bad field: ${pass_name}: $key" );
         $property_counts{$key} += 1;
      }
   }
}

say("\nKEY SUMMARY:");
say("Total passwords: $total_passwords");
my @keys =
  sort { $property_counts{$a} <=> $property_counts{$b} } keys(%property_counts);
my @vals = @property_counts{@keys};
foreach my $key ( keys %property_counts ) {
   say("$key: $property_counts{$key}");
}

say("\nEMAIL SUMMARY:");
foreach my $email ( sort { $email_counts{$b} <=> $email_counts{$a} }
   keys %email_counts )
{
   say "$email: $email_counts{$email}";
}
