#!perl

use strict;
use warnings;

use Test::More tests => 8;
use Test::Exception;

use File::Path qw/remove_tree make_path/;
use File::Spec;

my $exited;
BEGIN { *CORE::GLOBAL::exit = sub { $exited++ } };

ok( @ARGV = (
    '-t',
    File::Spec->abs2rel( File::Spec->catdir( File::Spec->curdir, 't', '.module-template', 'templates' ) ),
    '-c',
    File::Spec->abs2rel( File::Spec->catfile( File::Spec->curdir, 't', '.module-template', 'config' ) ),
    '-m',
    'Some::Test',
), 'set @ARGV' );

use_ok( 'App::Module::Template', 'run' );

ok( my $module_dir = File::Spec->catdir( File::Spec->curdir, 'Some-Test' ), 'set module directory' );

# make sure we have a clean environment
SKIP: {
    skip( 'module directory does not exist', 1 ) unless -d $module_dir;
    ok( remove_tree($module_dir), 'remove module directory' );
}

ok( make_path($module_dir), 'create module path' );

ok( run(@ARGV), 'run' );

is( $exited, 1, 'exits on module path exists' );

SKIP: {
    skip( 'module directory does not exist', 1 ) unless -d $module_dir;
    ok( remove_tree($module_dir), 'remove module directory' );
}
