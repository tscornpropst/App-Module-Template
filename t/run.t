#!perl

use strict;
use warnings FATAL => 'all';

use Test::More tests => 5;
use Test::Exception;

use File::Path qw/remove_tree/;
use File::Spec;

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

ok( run(@ARGV), 'run() w/ module name' );

ok( remove_tree($module_dir), 'removing module directory' );

is( -d $module_dir, undef, 'module directory removed' );
