#!perl

use strict;
use warnings FATAL => 'all';

use Test::More tests => 8;

use_ok( 'App::Module::Template', 'process_dirs' );

ok( chdir './t/fixtures', 'change directory to test dir' );

ok( my $test_dir = 'test_dir', 'set $test_dir' );

ok( my $dest_dir = process_dirs($test_dir), 'process_dirs()' );

like( $dest_dir, qr{/$test_dir\z}, 'destination dir returned' );

ok( -d $test_dir, 'test directory exists' );

ok( rmdir $test_dir, 'removing test dir' );

is( -d $test_dir, undef, 'test directory does not exist' );
