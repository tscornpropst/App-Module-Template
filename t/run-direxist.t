#!perl

use strict;
use warnings;

use Test::More tests => 6;
use Test::Exception;

use File::Path qw/remove_tree make_path/;
use File::Spec;

my $exited;
BEGIN { *CORE::GLOBAL::exit = sub { $exited++ } };

@ARGV = (
    '-t',
    File::Spec->abs2rel( File::Spec->catdir( File::Spec->curdir, 't', '.module-template', 'templates' ) ),
    '-c',
    File::Spec->abs2rel( File::Spec->catfile( File::Spec->curdir, 't', '.module-template', 'config' ) ),
    'Some::Test',
);

use_ok( 'App::Module::Template', 'run' );

ok( my $module_dir = File::Spec->catdir( File::Spec->curdir, 'Some-Test' ), 'set module directory' );

# make sure we have a clean environment
if ( -d $module_dir ) { remove_tree($module_dir); };

ok( make_path($module_dir), 'create module path' );

run(@ARGV);
is( $exited, 1, 'exits on module path exists' );

ok( remove_tree($module_dir), 'removing module directory' );

is( -d $module_dir, undef, 'module directory removed' );
