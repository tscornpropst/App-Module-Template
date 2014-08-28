#!perl

use strict;
use warnings;

use Test::More tests => 5;
use Test::Exception;

use File::Path qw/remove_tree/;
use File::Spec;

my $exited;
BEGIN { *CORE::GLOBAL::exit = sub { $exited++ } };

@ARGV = (
    '-t',
    File::Spec->abs2rel( File::Spec->catdir( File::Spec->curdir, 't', '.module-template', 'templates' ) ),
    '-c',
    File::Spec->abs2rel( File::Spec->catfile( File::Spec->curdir, 't', '.module-template', 'config' ) ),
    'some::test',
);

use_ok( 'App::Module::Template', 'run' );

ok( my $module_dir = File::Spec->catdir( File::Spec->curdir, 'some-test' ), 'set module directory' );

# make sure we have a clean environment
if ( -d $module_dir ) { remove_tree($module_dir); };

run(@ARGV);
is( $exited, 1, 'exits on bad module name' );

ok( remove_tree($module_dir), 'removing module directory' );

is( -d $module_dir, undef, 'module directory removed' );
