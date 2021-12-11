package Gita;
use File::Find::Rule;
use File::Basename;

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
    $depth = $self->{'depth_level'};
    print "Searching .git in dir ($source) with depth $depth.\n";
    print($dir);
    my @gitdirs = File::Find::Rule
                ->directory
                ->name('.git')
                ->maxdepth($depth)
                ->mindepth($depth)
                ->in($source);
    return @gitdirs

}

sub call_git_command {
    my $self = shift;
    my $subcommands = shift;
    my $dry_run = $self->{'dry_run'};
    my $depth = $self->{'depth_level'};
    my $source = $self->{'source_path'};
    my @gitdirs = map {File::Basename::dirname($_)} $self->search_git_dirs();
    if(!@gitdirs) {
        print "Did not find any git directories.\n";
        exit 1;
    }
    
    foreach(@gitdirs) {
        my $command = "/usr/bin/env git -C $_ ".$subcommands;
        if($dry_run == 1) {
            print "Would call command:\n$command\n";
        } else {
            print "\nRepository: ", File::Basename::basename($_), "\n\n";
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