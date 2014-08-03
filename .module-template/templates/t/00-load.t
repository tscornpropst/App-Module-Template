#!perl -T

use strict;
use warnings FATAL => 'all';

use Test::More tests => 1;

use_ok( '[% module %]' );

diag( "Testing [% module %] $[% module %]::VERSION, Perl $], $^X" );
