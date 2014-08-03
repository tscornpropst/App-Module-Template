#!perl -T

use strict;
use warnings FATAL => 'all';

use Test::More tests => 1;

use_ok( 'App::Module::Template' );

diag( "Testing App::Module::Template $App::Module::Template::VERSION, Perl $], $^X" );
