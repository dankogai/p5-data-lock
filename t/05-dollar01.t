#!perl -T
#
# $Id: 04-dlock.t,v 1.1 2013/05/13 15:31:54 dankogai Exp dankogai $
#
use strict;
use warnings;
use Data::Lock qw/dlock dunlock/;

#use Test::More 'no_plan';
use Test::More tests => 4;

dlock my $o = 0;
ok Internals::SvREADONLY($o);
ok !Internals::SvREADONLY($0);
dlock my $z = 1;
ok Internals::SvREADONLY($z);
ok !Internals::SvREADONLY($1);
