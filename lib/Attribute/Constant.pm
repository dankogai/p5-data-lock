package Attribute::Constant;
use 5.008001;
use warnings;
use strict;
our $VERSION = sprintf "%d.%02d", q$Revision: 0.6 $ =~ /(\d+)/g;
use Attribute::Handlers;
use Data::Lock ();

sub UNIVERSAL::Constant : ATTR {
    my ( $pkg, $sym, $ref, $attr, $data, $phase ) = @_;
    (
          ref $ref eq 'HASH'  ? %$ref
        : ref $ref eq 'ARRAY' ? @$ref
        :                       ($$ref)
      )
      = ref $data
      ? ref $data eq 'ARRAY'
          ? @$data    # perl 5.10.x
          : $data
      : $data;        # perl 5.8.x
    Data::Lock::dlock($ref);
}

1;
__END__

=head1 NAME

Attribute::Constant - Make read-only variables via attribute

=head1 VERSION

$Id: Constant.pm,v 0.6 2013/03/20 22:37:04 dankogai Exp dankogai $

=head1 SYNOPSIS

 use Attribute::Constant;
 my $sv : Constant( $initial_value );
 my @av : Constant( @values );
 my %hv : Constant( key => value, key => value, ...);

=head1 DESCRIPTION

This module uses L<Data::Lock> to make the variable read-only.  Check
the document and source of L<Data::Lock> for its mechanism.

=head1 ATTRIBUTES

This module adds only one attribute, C<Constant>.  You give its
initial value as shown.  Unlike L<Readonly>, parantheses cannot be
ommited but it is semantically more elegant and thanks to
L<Data::Lock>, it imposes almost no performance penalty.

=head1 CAVEAT

Multi-line attributes are not allowed in Perl 5.8.x.

  my $o : Constant(Foo->new(one=>1,two=>2,three=>3));    # ok
  my $p : Constant(Bar->new(
                            one   =>1,
                            two   =>2,
                            three =>3
                           )
                 ); # needs Perl 5.10

In which case you can use L<Data::Lock> instead:

  dlock(my $p = Bar->new(
        one   => 1,
        two   => 2,
        three => 3
    )
  );

After all, this module is a wrapper to L<Data::Lock>;

=head1 BENCHMARK

Here I have benchmarked like this.

  1.  Create an immutable variable.
  2.  try to change it and see if it raises exception
  3.  make sure the value stored remains unchanged.

See F<t/benchmark.pl> for details.

=over 2

=item Simple scalar

                Rate  Readonly      glob Attribute
  Readonly    7803/s        --      -97%      -97%
  glob      281666/s     3510%        --       -5%
  Attribute 295780/s     3691%        5%        --

=item Array with 1000 entries

                Rate  Readonly Attribute
  Readonly    8589/s        --      -97%
  Attribute 278755/s     3145%        --

=item Hash with 1000 key/value pairs

                Rate  Readonly Attribute
  Readonly    6979/s        --      -97%
  Attribute 207526/s     2874%

=back

=head1 SEE ALSO

L<Data::Lock>, L<constant>

=head1 AUTHOR

Dan Kogai, C<< <dankogai+cpan at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-attribute-constant
at rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Attribute-Constant>.
I will be notified, and then you'll automatically be notified of
progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Attribute::Constant

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Attribute-Constant>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Attribute-Constant>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Attribute-Constant>

=item * Search CPAN

L<http://search.cpan.org/dist/Attribute-Constant>

=back

=head1 ACKNOWLEDGEMENTS

L<Readonly>

=head1 COPYRIGHT & LICENSE

Copyright 2008 Dan Kogai, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

