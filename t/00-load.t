#!perl -T
use 5.016;
use strict;
use warnings FATAL => 'all';
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'App::Module::Template' ) || print "Bail out!\n";
}

diag( "Testing App::Module::Template $main::VERSION, Perl $], $^X" );
