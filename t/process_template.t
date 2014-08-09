#!perl

use strict;
use warnings FATAL => 'all';

use Test::More;# tests=> ??;
use Test::Exception;

use Cwd;
use Template;

use_ok( 'App::Module::Template', 'process_template' );

ok( my $fake_tmpl_path = join( q{/}, cwd, 'some-non-dir' ), 'set fake template path' );

ok( my $abs_tmpl_path = join( q{/}, cwd, 't/.module-template/templates/Changes' ), 'set fake template path' );
#
ok( my $abs_output_path = join( q{/}, cwd, 'test_dir' ), 'set output path' );

ok( my $tt2 = Template->new({ABSOLUTE => 1, OUTPUT_PATH => $abs_output_path}), 'create absolute TT2 object' );

ok( my $tmpl_vars = {}, 'set $tmpl_vars' );

throws_ok{ process_template($tt2, $tmpl_vars, $fake_tmpl_path, undef) } qr/some/, 'process_template throws error';

ok( process_template($tt2, $tmpl_vars, $abs_tmpl_path, undef), 'process_template()' );

done_testing();