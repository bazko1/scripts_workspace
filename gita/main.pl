use strict;
use warnings;

sub run_command  {

}

sub check_git_binary {
    my $git_version = `/usr/bin/env git --version 2>&1`;
    my $r_c = $?;
    print "$git_version";
    return $r_c
}



# my out = `/usr/bin/env git --version`
# my $output = `git --help`;
# print $output;
my $out = check_git_binary();
print "OUT=$out\n"