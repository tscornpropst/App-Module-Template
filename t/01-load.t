#!perl -T

use strict;
use warnings FATAL => 'all';

use Test::More tests => 1;

use_ok( 'App::Module::Template::Initialize' );

diag( "Testing App::Module::Template::Initialize $App::Module::Template::Initialize::VERSION, Perl $], $^X" );
