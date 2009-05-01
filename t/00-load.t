#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'MooseX::Error::Trap' );
}

diag( "Testing MooseX::Error::Trap $MooseX::Error::Trap::VERSION, Perl $], $^X" );
