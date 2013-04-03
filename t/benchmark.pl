#!perl
#
# $Id: benchmark.pl,v 1.0 2013/04/03 06:49:25 dankogai Exp dankogai $
#
use strict;
use warnings;
use Benchmark qw/timethese cmpthese/;
use Attribute::Constant;
use Readonly;

my $sa : Constant(1);
Readonly my $sr => 1;
local *sg = \1; our $sg;

cmpthese(
    timethese(
        0,
        {
            Attribute => sub{
                eval { $sa++ }; die unless $@; $sa == 1 or die;
            },
            Readonly => sub {
                eval { $sr++ }; die unless $@; $sr == 1 or die;
            },
            glob => sub {
                eval { $sg++ }; die unless $@; $sg == 1 or die;
            },
        }
    )
);

my @aa : Constant( 1 .. 1000 );
Readonly my @ar => ( 1 .. 1000 );

cmpthese(
    timethese(
        0,
        {
            Attribute => sub{
		eval { pop @aa }; die unless $@; $aa[0] == 1 or die;
	    },
            Readonly => sub {
		eval { pop @ar }; die unless $@; $ar[0] == 1 or die;
	    },
	}
    )
);

my %ha : Constant( map { $_ => $_*$_ } 1 .. 1000 );
Readonly my %hr => ( map { $_ => $_ * $_ } 1 .. 1000 );

cmpthese(
    timethese(
        0,
        {
	    Attribute => sub{
		eval { $ha{zero}++ }; die unless $@; $ha{1000} == 1e6 or die;
	    },
            Readonly => sub {
		eval { $hr{zero}++ }; die unless $@; $hr{1000} == 1e6 or die;
	    },
        }
    )
);
