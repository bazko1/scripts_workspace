package Gita;

sub new {

    my $class = shift;

    my $self = {
        "source_path" => shift,
        "depth_level" => shift,
    };

    
    bless $self, $class;
    print("Creating Gita class: ", $self->{'source_path'}," ", $self->{'depth_level'},"\n");
    
    return $self;
}

# search .git/ directories
sub search_git_repos {
    my $self = shift;
    $source = $self->{'source_path'};
    $depth = $self->{'depth_level'};
    print "search in $source\n";
    use File::Find::Rule;
    print($dir);
    my @gitdirs = File::Find::Rule
                ->directory
                ->name('.git')
                ->maxdepth($depth)
                ->in($source);
    print("dirs:= @gitdirs\m");
    return @gitdirs

}

sub call_git_command {
    my $self = shift;
    my $command = shift;
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