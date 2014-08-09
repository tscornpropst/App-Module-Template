#!perl -T

use strict;
use warnings FATAL => 'all';

use Test::More tests => 4;

use_ok( 'App::Module::Template', '_get_module_fqfn' );

ok( my $dirs = ['lib', 'Part1', 'Part2'], 'set $dirs' );

ok( my $file = 'Module.pm', 'set $file' );

is(
  _get_module_fqfn($dirs, $file), 'lib/Part1/Part2/Module.pm', 'get_module_fqfn'
);
