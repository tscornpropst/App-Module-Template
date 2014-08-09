#!perl

use strict;
use warnings FATAL => 'all';

use Test::More tests => 25;

use Cwd;
use File::Path qw/remove_tree/;
use Template;

use_ok( 'App::Module::Template', '_process_dirs' );

ok( my $rel_tmpl_path = './t/.module-template/templates', 'set relative template path' );

ok( my $rel_output_path = './test_dir', 'set relative output path' );

ok( my $rel_tt2 = Template->new({RELATIVE => 1, OUTPUT_PATH => $rel_output_path}), 'create relative TT2 object' );

ok( my $tmpl_vars = {}, 'set $tmpl_vars' );

ok( _process_dirs($rel_tt2, $tmpl_vars, $rel_tmpl_path, $rel_tmpl_path), '_process_dirs() w/ relative paths' );

ok( -d "$rel_output_path/bin", 'bin exists' );
ok( -d "$rel_output_path/lib", 'bin exists' );
ok( -d "$rel_output_path/t", 't exists' );
ok( -d "$rel_output_path/xt", 'xt exists' );
ok( -d "$rel_output_path/xt/author", 'xt/author exists' );
ok( -d "$rel_output_path/xt/release", 'xt/release exists' );

ok( -f "$rel_output_path/Changes", 'Changes exists' );
ok( -f "$rel_output_path/LICENSE", 'LICENSE exists' );
ok( -f "$rel_output_path/Makefile.PL", 'Makefile.PL exists' );
ok( -f "$rel_output_path/README", 'README exists' );
ok( -f "$rel_output_path/bin/app.pl", 'app.pl exists' );
ok( -f "$rel_output_path/lib/Module.pm", 'Module.pm exists' );
ok( -f "$rel_output_path/t/00-load.t", '00-load.t exists' );
ok( -f "$rel_output_path/xt/author/pod-coverage.t", 'pod-coverage.t exists' );
ok( -f "$rel_output_path/xt/author/critic.t", 'critic.t exists' );
ok( -f "$rel_output_path/xt/author/perlcritic.rc", 'perlcritic.rc exists' );
ok( -f "$rel_output_path/xt/release/pod-syntax.t", 'pod-syntax.t exists' );

ok( remove_tree($rel_output_path), 'removing output path' );

is( -d $rel_output_path, undef, 'output path is removed' );
