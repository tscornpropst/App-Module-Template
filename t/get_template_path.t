#!perl

use strict;
use warnings FATAL => 'all';

use Test::More tests => 10;
use Test::Exception;

use Cwd;
use File::HomeDir;
use File::Path qw/remove_tree make_path/;

use_ok( 'App::Module::Template', '_get_template_path' );

ok( my $path = join( q{/}, cwd, 'test_dir' ), 'set path' );

throws_ok{ _get_template_path($path) } qr/\ATemplate directory/, 'fails for non-existent path';

ok( make_path($path), 'create path' );

ok( -d $path, 'path exists' );

is( _get_template_path($path), $path, 'returns path' );

ok( remove_tree($path), 'removing path' );

is( -d $path, undef, 'path removed' );

ok( my $home_path = join( q{/}, File::HomeDir->my_home(), '.module-template/templates' ), 'set home path' );

is( _get_template_path(), $home_path, 'returns path');
