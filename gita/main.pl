#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename;
use lib dirname (__FILE__);
use Gita;
use Cwd;
use Getopt::Long;

sub main {

    sub process {
        my $arg = shift;
        print "unknown arg $arg\n";
    }
    Getopt::Long::Configure ("require_order", "pass_through");
    our $opt_depth = 2;
    our $opt_dry_run = 0;
    our $opt_path = getcwd();
    GetOptions( 'dry-run',
                'depth=i',
                'path=s');
    my $depth = $opt_depth;
    my $dry_run = $opt_dry_run;
    my $path = $opt_path;

    my @gitCommands=@ARGV;
    print "gitCommands=", join(" ", @gitCommands), "\n";
    
    my $gita = new Gita($path, $depth, $dry_run);
    $gita->check_git_binary();
    $gita->search_git_repos();
    $gita->call_git_command(join(" ", @gitCommands));
}
main();