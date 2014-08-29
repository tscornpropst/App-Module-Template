#!perl

use strict;
use warnings;

use Test::More tests => 7;
use Test::Exception;

use File::Path qw/remove_tree/;
use File::Spec;

my $exited;
BEGIN { *CORE::GLOBAL::exit = sub { $exited++ } };

ok( @ARGV = (
    '-t',
    File::Spec->abs2rel( File::Spec->catdir( File::Spec->curdir, 't', '.module-template', 'templates' ) ),
    '-c',
    File::Spec->abs2rel( File::Spec->catfile( File::Spec->curdir, 't', '.module-template', 'config' ) ),
    '-m',
    'some::test',
), 'set @ARGV' );

use_ok( 'App::Module::Template', 'run' );

ok( my $module_dir = File::Spec->catdir( File::Spec->curdir, 'some-test' ), 'set module directory' );

# make sure we have a clean environment
SKIP: {
    skip( 'module directory does not exist', 1 ) unless -d $module_dir;
    ok( remove_tree($module_dir), 'remove module directory' );
}

ok( run(@ARGV), 'run' );

is( $exited, 1, 'exits on bad module name' );

SKIP: {
    skip( 'module directory does not exist', 1 ) unless -d $module_dir;
    ok( remove_tree($module_dir), 'remove module directory' );
}

