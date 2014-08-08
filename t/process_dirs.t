#!perl

use strict;
use warnings FATAL => 'all';

use Test::More tests => 9;
use Cwd;

use_ok( 'App::Module::Template', 'process_dirs' );

ok( my $test_dir = join( q{/}, cwd, 'test_dir'), 'set $test_dir' );

ok( my $dest_dir = process_dirs($test_dir), 'process_dirs()' );

like( $dest_dir, qr{$test_dir\z}, 'destination dir returned' );

ok( -d $test_dir, 'test directory exists' );

ok( rmdir $test_dir, 'removing test dir' );

is( -d $test_dir, undef, 'test directory does not exist' );

is( process_dirs('templates'), undef, 'process dirs skips .module-template' );

is( process_dirs('.module-template'), undef, 'process dirs skips .module-template' );
