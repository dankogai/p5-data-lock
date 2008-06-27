#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Attribute::Constant' );
}

diag( "Testing Attribute::Constant $Attribute::Constant::VERSION, Perl $], $^X" );
