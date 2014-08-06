#!perl

use strict;
use warnings FATAL => 'all';

use Test::More tests => 21;
use Test::Exception;
use Template;
use Cwd;

use_ok( 'App::Module::Template', 'process_files', 'process_template' );

ok( my $tt2 = Template->new({RELATIVE => 1}), 'create template toolkit' );

ok( chdir './t/fixtures', 'change directory to test dir' );

ok( my $cwd = cwd, 'set current working directory' );

ok( my $file = '../.module-template/templates/Changes', 'set file name' );

ok( -f $file, 'file found' );

ok( my $dest_file = join(q{/}, $cwd, 'Changes'), 'set dest file name' );

is( process_files($tt2, $file), $dest_file, 'process_files()' );

ok( -f $dest_file, 'destination file exists' );

ok( unlink $dest_file, 'removing destination file' );

is( -f $dest_file, undef, 'destination file deleted' );

ok( my $file2 = '../.module-template/templates/t/00-load.t', 'set file name' );

ok( my $dest_file2 = join(q{/}, $cwd, 't', '00-load.t'), 'set dest file name' );

is( process_files($tt2, $file2), $dest_file2, 'process_files()' );

ok( -f $dest_file2, 'destination file exists' );

ok( unlink $dest_file2, 'removing destination file' );

is( -f $dest_file2, undef, 'destination file deleted' );


ok( my $swap_file = 'test.swp', 'set swap file name' );

is( process_files($tt2, $swap_file), undef, 'attempt to process swap file' );

# cause TT to puke

ok( my $new_tt = Template->new(), 'create error prone template toolkit' );

throws_ok{ process_files($new_tt, $file) } qr/T.*/, 'tt fails with error';
