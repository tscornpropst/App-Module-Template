#!perl

use strict;
use warnings FATAL => 'all';

use Test::More tests => 10;

use Cwd;
use File::Path qw/make_path remove_tree/;

use_ok( 'App::Module::Template', '_module_path_exists' );

ok( my $module_path = join( q{/}, cwd, 'test_dir' ), 'set module path' );

is( -d $module_path, undef, 'module path does not exist' );

is( _module_path_exists(undef), undef, 'module path does not exist' );

is( _module_path_exists($module_path), undef, 'module path does not exist' );

ok( make_path($module_path), 'create module path' );

ok( -d $module_path, 'module path exists' );

ok( _module_path_exists($module_path), 'module path exists' );

ok( remove_tree($module_path), 'removing module path' );

is( -d $module_path, undef, 'module path removed' );
