__END__
=encoding utf8
=head1 NAME

gita - utility enhancing git command line tool

=head1 SYNOPSIS

gita [OPTIONS] [GIT_COMMANDS]

=head1 OPTIONS

=over 4

=item B<--help|-h>

    Print a brief help message and exits.

=item B<--path PATH>
    
    Path to start searching for git repositories from. (String)
    If not specified default value is current working directory.

=item B<--depth DEPTH>
    
    Integer representing recurisivity search depth level.
    If not specified default value is 2.

=item B<--dry-run>
    
    Do not call any git command only print what would happen.

=back

=head1 GIT_COMMANDS


Commands and flags to be called using git tool.

The commands should be those operating on already 
    initialized git working area (init/clone does not make sense).
        
For supported commands see `git --help` - work, examine, grow, collaborate sections.

=head1 DESCRIPTION

B<This program> will search recursively for git repositories in given path and
perform git operation on each found repository. 

This allows user implementing feature that modify more than one repository to update
multiple repositories using single call.

=head1 EXAMPLES

This directory have following structure:

    ├── gita 
    ├── Gita.pm
    ├── test
    │   ├── repo1
    │   │   └── .git
    │   └── repo2
            └── .git

# Calling bellow command will list status of repo1 and repo2

> ./gita --depth 3 status

# Calling bellow command will create new branch in repo1 and repo2

> ./gita --path ./test checkout -b Feature4

# Calling bellow command will add all modified filles in repo1 and repo2

> ./gita --depth 3 add -u

# Calling bellow command will commit changes in repo1 and repo2.

# Note currenlty whitespaces are not supported for argument commit cant be "New feature"

> ./gita --depth 3 commit -m Feature/4

# Calling bellow command will push new commits (if remote configured)

> ./gita --depth 3 push

=cut