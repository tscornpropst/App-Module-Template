#!perl

use strict;
use warnings FATAL => 'all';

use Test::More tests => 8;

use_ok( 'App::Module::Template', 'process_file' );

ok( my $rel_tmpl_path = './t/.module-template/templates', 'set template path' );

ok( my $tmpl_file = 't/00-load.t', 'set template file' );

ok( my $rel_source_file = join( q{/}, $rel_tmpl_path, $tmpl_file ), 'set source file path' );

is( process_file($rel_tmpl_path, $rel_source_file), $tmpl_file, 'process_file returns stub' );

ok( my $tmpl_file2 = 'xt/author/critic.t', 'set template file' );

ok( my $rel_source_file2 = join( q{/}, $rel_tmpl_path, $tmpl_file2 ), 'set source file path' );

is( process_file($rel_tmpl_path, $rel_source_file2), $tmpl_file2, 'process_file returns stub' );
