package lib::relative;

use strict;
use warnings;
use File::Basename ();
use File::Spec;
use lib ();

our $VERSION = '0.001';

sub import {
  my ($class, @paths) = @_;
  my $dir = File::Spec->rel2abs(File::Basename::dirname((caller)[1]));
  lib->import(map { File::Spec->file_name_is_absolute($_) ? $_ : "$dir/$_" } @paths);
}

1;

=head1 NAME

lib::relative - Add relative paths to @INC correctly

=head1 SYNOPSIS

  use lib::relative 'path/to/lib';
  
  # Equivalent code using core modules:
  use File::Basename ();
  use File::Spec;
  use lib File::Spec->rel2abs(File::Basename::dirname(__FILE__)) . '/path/to/lib');

=head1 DESCRIPTION

Adding a path to L<perlvar/"@INC"> to load modules from a custom relative
directory may seem simple, but has a few common pitfalls to be aware of.
Directly adding a relative path to C<@INC>, such as the C<.> path that used to
be in C<@INC> by default until perl 5.26.0, or with a line like
C<use lib 'path/to/lib';>, means that any later code that changes the current
directory will change where you load modules from. This may be a vulnerability
if such a location is not supposed to be writable. Additionally, the commonly
used L<FindBin> module relies on interpreter state and the path relative to the
original script invoked by the perl interpreter. This module proposes a more
straightforward method: add the absolute path of a directory relative to the
current file to C<@INC>.

If you are able to load this module first, you can simply use the module as you
would use L<lib>, passing the relative path, which will be absolutized
relative to the current file then passed on to L<lib>. If not, the second part
of the L</"SYNOPSIS"> can be copy-pasted into a file to perform the same task.

When using C<lib::relative>, multiple import arguments will be separately
absolutized and passed on to L<lib>, and absolute paths will be passed on to
L<lib> unchanged.

=head1 CAVEATS

Due to C<__FILE__> possibly being a path relative to the current working
directory, be sure to use C<lib::relative> or the equivalent code from
L</"SYNOPSIS"> as early as possible in the file. If a C<chdir> occurs before
this code, it will add the incorrect directory path.

This probably does not work on VMS.

=head1 BUGS

Report any issues on the public bugtracker.

=head1 AUTHOR

Dan Book <dbook@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2017 by Dan Book.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)

=head1 SEE ALSO

L<lib>, L<FindBin>, L<Dir::Self>
