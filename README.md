[![build status](https://secure.travis-ci.org/dankogai/p5-data-lock.png)](http://travis-ci.org/dankogai/p5-data-lock)

# NAME

Data::Lock - makes variables (im)?mutable

# VERSION

$Id: Lock.pm,v 1.3 2014/03/07 18:24:43 dankogai Exp dankogai $

# SYNOPSIS

    use Data::Lock qw/dlock dunlock/;

    dlock my $sv = $initial_value;
    dlock my $ar = [@values];
    dlock my $hr = { key => value, key => value, ... };
    dunlock $sv;
    dunlock $ar; dunlock \@av;
    dunlock $hr; dunlock \%hv;

# DESCRIPTION

`dlock` makes the specified variable immutable like [Readonly](https://metacpan.org/pod/Readonly).
Unlike [Readonly](https://metacpan.org/pod/Readonly) which implements immutability via `tie`, `dlock`
makes use of the internal flag of perl SV so it imposes almost no
penalty.

Like [Readonly](https://metacpan.org/pod/Readonly), `dlock` locks not only the variable itself but also
elements therein.

As of verion 0.03, you can `dlock` objects as well.  Below is an
example constructor that returns an immutable object:

    sub new {
        my $pkg = shift;
        my $self = { @_ };
        bless $self, $pkg;
        dlock($self);
        $self;
    }

Or consider using [Moose](https://metacpan.org/pod/Moose).

# EXPORT

Like [List::Util](https://metacpan.org/pod/List%3A%3AUtil) and [Scalar::Util](https://metacpan.org/pod/Scalar%3A%3AUtil), functions are exported only
explicitly. This module comes with `dlock` and `dunlock`.

    use Data::Lock;                   # nothing imported;
    use Data::Lock qw/dlock dunlock/; # imports dlock() and dunlock()

# FUNCTIONS

## dlock

    dlock($scalar);

Locks `$scalar` and if `$scalar` is a reference, recursively locks referents.

## dunlock

Does the opposite of `dlock`.

# BENCHMARK

Here I have benchmarked like this.

    1.  Create an immutable variable.
    2.  try to change it and see if it raises exception
    3.  make sure the value stored remains unchanged.

See `t/benchmark.pl` for details.

- Simple scalar

                      Rate  Readonly Attribute      glob     dlock
        Readonly   11987/s        --      -98%      -98%      -98%
        Attribute 484562/s     3943%        --       -1%       -4%
        glob      487239/s     3965%        1%        --       -3%
        dlock     504247/s     4107%        4%        3%        --

- Array with 1000 entries

                      Rate  Readonly     dlock Attribute
        Readonly   12396/s        --      -97%      -97%
        dlock     444703/s     3488%        --       -6%
        Attribute 475557/s     3736%        7%        --

- Hash with 1000 key/value pairs

                      Rate  Readonly     dlock Attribute
        Readonly   10855/s        --      -97%      -97%
        dlock     358867/s     3206%        --       -5%
        Attribute 377087/s     3374%        5%        --

# SEE ALSO

[Readonly](https://metacpan.org/pod/Readonly), [perlguts](https://metacpan.org/pod/perlguts), [perlapi](https://metacpan.org/pod/perlapi)

# AUTHOR

Dan Kogai, `<dankogai at cpan.org>`

# BUGS

Please report any bugs or feature requests to `bug-data-lock at
rt.cpan.org`, or through the web interface at
[http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-Lock](http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Data-Lock).  I will
be notified, and then you'll automatically be notified of progress on
your bug as I make changes.

# SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Data::Lock

You can also look for information at:

- RT: CPAN's request tracker

    [http://rt.cpan.org/NoAuth/Bugs.html?Dist=Data-Lock](http://rt.cpan.org/NoAuth/Bugs.html?Dist=Data-Lock)

- AnnoCPAN: Annotated CPAN documentation

    [http://annocpan.org/dist/Data-Lock](http://annocpan.org/dist/Data-Lock)

- CPAN Ratings

    [http://cpanratings.perl.org/d/Data-Lock](http://cpanratings.perl.org/d/Data-Lock)

- Search CPAN

    [http://search.cpan.org/dist/Data-Lock](http://search.cpan.org/dist/Data-Lock)

# COPYRIGHT & LICENSE

Copyright 2008-2020 Dan Kogai, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.
