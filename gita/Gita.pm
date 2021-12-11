package Gita;
use File::Basename;
use File::Find;

sub new {

    my $class = shift;

    my $self = {
        "source_path" => shift,
        "depth_level" => shift,
        "dry_run" => shift
    };

    bless $self, $class;

    return $self;
}

# search .git/ directories
sub search_git_dirs {
    my $self = shift;
    $source = $self->{'source_path'};
    $source =~ s/\/+$//;
    $depth = $self->{'depth_level'};
    print "Searching .git in dir ($source) with depth $depth.\n";
    my @gitdirs;

    sub wanted {
        my $sub = $File::Find::name;
        $sub =~ s/$source//;
        -d &&
        "$_" eq ".git" &&
        $sub =~ tr[/][] eq $depth &&
        push(@gitdirs, $File::Find::dir);
    };

    find(\&wanted, "$source");
    return @gitdirs

}

# Call git command on recursively found .git repositories
sub call_git_command {
    my $self = shift;
    my $subcommands = shift;
    my $dry_run = $self->{'dry_run'};
    my $depth = $self->{'depth_level'};
    my $source = $self->{'source_path'};
    my @gitdirs = $self->search_git_dirs();
    if(!@gitdirs) {
        print "Did not find any git directories.\n";
        exit 1;
    }

    foreach(@gitdirs) {
        my $command = "/usr/bin/env git -C $_ ".$subcommands;
        print "-" x 30,
              "\nRepository: ",
              File::Basename::basename($_),
              "\n\n";
        if($dry_run == 1) {
            print "Would call command:\n$command\n";
        } else {
            system $command;
        }
    }

    return 0;
}

# checks if there is git binary installed
sub check_git_binary {
    my $self = shift;
    my $git_version = `/usr/bin/env git --version 2>&1`;
    my $r_c = $?;
    print "$git_version";
    return $r_c;
}

1;