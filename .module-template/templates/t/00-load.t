#!perl -T

use strict;
use warnings FATAL => 'all';

use Test::More;

plan tests => 1;

BEGIN {
    use_ok( '[% module %]' ) || print "Bail out!\n";
}

diag( "Testing [% module %] $[% module %]::VERSION, Perl $], $^X" );
