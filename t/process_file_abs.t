#!perl

use strict;
use warnings FATAL => 'all';

use Test::More tests => 8;
use Cwd;

use_ok( 'App::Module::Template', 'process_file' );

ok( my $abs_tmpl_path = join( q{/}, cwd, 't/.module-template/templates' ), 'set template path' );

ok( my $tmpl_file = 't/00-load.t', 'set template file' );

ok( my $abs_source_file = join( q{/}, $abs_tmpl_path, $tmpl_file ), 'set source file path' );

is( process_file($abs_tmpl_path, $abs_source_file), $tmpl_file, 'process_file returns stub' );

ok( my $tmpl_file2 = 'xt/author/critic.t', 'set template file' );

ok( my $abs_source_file2 = join( q{/}, $abs_tmpl_path, $tmpl_file2 ), 'set source file path' );

is( process_file($abs_tmpl_path, $abs_source_file2), $tmpl_file2, 'process_file returns stub' );
