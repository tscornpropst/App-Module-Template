#!perl -T

use strict;
use warnings FATAL => 'all';

use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'App::Module::Template::Initialize' ) || print "Bail out!\n";
}

diag( "Testing $App::Module::Template::Initialize::VERSION, Perl $], $^X" );
