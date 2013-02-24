package Data::Lock;
use 5.008001;
use warnings;
use strict;
our $VERSION = sprintf "%d.%02d", q$Revision: 0.3 $ =~ /(\d+)/g;

use Attribute::Handlers;
use Scalar::Util ();

use base 'Exporter';
our @EXPORT_OK = qw/dlock dunlock/;

#my @builtin_types = 
#    qw/SCALAR ARRAY HASH CODE REF GLOB LVALUE FORMAT IO VSTRING Regexp/;

for my $locked ( 0, 1 ) {
    my $subname = $locked ? 'dlock' : 'dunlock';
    no strict 'refs';
    *{$subname} = sub {
        my $type = Scalar::Util::reftype( $_[0] );
        for (
              $type eq 'ARRAY' ? @{ $_[0] }
            : $type eq 'HASH'  ? values %{ $_[0] }
            : $type ne 'CODE'  ? ${ $_[0] }
            :                    ()
          )
        {
            dlock($_) if ref $_;
            Internals::SvREADONLY( $_, $locked );
        }
            $type eq 'ARRAY' ? Internals::SvREADONLY( @{ $_[0] }, $locked )
          : $type eq 'HASH'  ? Internals::SvREADONLY( %{ $_[0] }, $locked )
          : $type ne 'CODE'  ? Internals::SvREADONLY( ${ $_[0] }, $locked )
          :                    undef;
        Internals::SvREADONLY( $_[0], $locked );
    };
}

1;
__END__

=head1 NAME

Data::Lock - makes variables (im)?mutable

=head1 VERSION

$Id: Lock.pm,v 0.3 2013/02/24 07:03:27 dankogai Exp dankogai $

=head1 SYNOPSIS

   use Data::Lock qw/dlock dunlock/;

   # note parentheses and equal

   dlock( my $sv = $initial_value );
   dlock( my $ar = [@values] );
   dlock( my $hr = { key => value, key => value, ... } );
   dunlock $sv;
   dunlock $ar; dunlock \@av;
   dunlock $hr; dunlock \%hv;

=head1 DESCRIPTION

C<dlock> makes the specified variable immutable like L<Readonly>.
Unlike L<Readonly> which implements immutability via C<tie>, C<dlock>
makes use of the internal flag of perl SV so it imposes almost no
penalty.

Like L<Readonly>, C<dlock> locks not only the variable itself but also
elements therein.

As of verion 0.03, you can C<dlock> objects as well.  Below is an
example constructor that returns an immutable object:

  sub new {
      my $pkg = shift; 
      my $self = { @_ };
      bless $self, $pkg;
      dlock($self);
      $self;
  }

Or consider using L<Moose>.

=head1 EXPORT

Like L<List::Util> and L<Scalar::Util>, functions are exported only
explicitly. This module comes with C<dlock> and C<dunlock>.

  use Data::Lock;                   # nothing imported;
  use Data::Lock qw/dlock dunlock/; # imports dlock() and dunlock()

=head1 FUNCTIONS

=head2 dlock

  dlock($scalar);

Locks $scalar and if $scalar is a reference, recursively locks referents.

=head2 dunlock

Does the opposite of C<dlock>.

=head1 SEE ALSO

L<Readonly>, L<perlguts>, L<perlapi>

=head1 AUTHOR

Dan Kogai, C<< <dankogai+gmail at gmail.com> >>

=head1 BUGS & SUPPORT

See L<Attribute::Constant>.

=head1 COPYRIGHT & LICENSE

Copyright 2008 Dan Kogai, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

