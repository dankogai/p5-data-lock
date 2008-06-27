#!perl -T
#
# $Id: 04-dlock.t,v 0.1 2008/06/27 19:11:42 dankogai Exp $
#
use strict;
use warnings;
use Data::Lock qw/dlock dunlock/;

#use Test::More 'no_plan';
use Test::More tests => 10;

{
    dlock( my $a = [ 0, 1, 2, 3 ] );
    is_deeply [ 0, 1, 2, 3 ], $a, '$a => [0,1,2,3]';
    eval { shift @$a };
    ok $@, $@;
    eval { $a->[0]-- };
    ok $@, $@;
    dunlock $a;
    eval { $a->[0]-- };
    ok !$@, '$a->[0]--';
    is_deeply [ -1, 1, 2, 3 ], $a, '$a => [-1,1,2,3]';
}
{
    dlock( my $h = { one => 1, two => 2 } );
    is_deeply { one => 1, two => 2 }, $h, '$h => {one=>1, two=>2}';
    eval { $h = {} };
    ok $@, $@;
    eval { $h->{one}-- };
    ok $@, $@;
    dunlock $h;
    eval { $h->{one}-- };
    ok !$@, '$h->{one}--';
    is_deeply { one => 0, two => 2 }, $h, '$h => {one=>0, two=>2}';
}


__END__
#SCALAR
ARRAY
HASH
#CODE
#REF
#GLOB
#LVALUE
#FORMAT
#IO
#VSTRING
#Regexp


__END__
#SCALAR
ARRAY
HASH
#CODE
#REF
#GLOB
#LVALUE
#FORMAT
#IO
#VSTRING
#Regexp

