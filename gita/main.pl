#!/usr/bin/env perl
use strict;
use warnings;
use File::Basename;
use lib dirname (__FILE__);
use Gita;
use Cwd;

sub main {
    my $gita = new Gita(getcwd(), 2);
    $gita->check_git_binary();
    $gita->search_git_repos();
    $gita->call_git_command("foo");
}
main();