#!perl

use strict;
use warnings FATAL => 'all';

use Test::More tests => 13;
use Test::Exception;

use File::HomeDir;
use File::Path qw/remove_tree make_path/;
use File::Spec;

use_ok( 'App::Module::Template', '_get_template_path' );

ok( my $path = File::Spec->catdir( File::Spec->curdir, 'test_dir' ), 'set path' );

throws_ok{ _get_template_path($path) } qr/\ATemplate directory/, 'fails for non-existent path';

ok( make_path($path), 'create path' );

ok( -d $path, 'path exists' );

is( _get_template_path($path), $path, 'returns path' );

ok( remove_tree($path), 'removing path' );

is( -d $path, undef, 'path removed' );

ok( my $home_path = File::Spec->catdir( File::HomeDir->my_home(), '.module-template', 'templates' ), 'set home path' );

ok( my $home_tmpl_path = File::Spec->catdir( $home_path, 'templates' ), 'set home template path' );

SKIP: {
    skip( 'home path does not exist', 3) unless -d $home_path;

    is( _get_template_path(), $home_tmpl_path, 'returns path');

    ok( remove_tree($home_path), 'removing .module-template dir');

    is( -d $home_path, undef, '.module-template dir removed' );
}
