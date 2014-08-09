#!perl

use strict;
use warnings FATAL => 'all';

use Test::More tests => 31;
use Test::Exception;

use Cwd;
use File::Path qw/remove_tree make_path/;
use Template;

use_ok( 'App::Module::Template', '_process_dirs' );

ok( my $abs_tmpl_path = join( q{/}, cwd, 't/.module-template/templates' ), 'set template path' );

ok( my $abs_output_path = join( q{/}, cwd, 'test_dir' ), 'set output path' );

ok( my $abs_tt2 = Template->new({ABSOLUTE => 1, OUTPUT_PATH => $abs_output_path}), 'create absolute TT2 object' );

ok( my $tmpl_vars = {}, 'set $tmpl_vars' );

ok( my $cant_read = join( q{/}, cwd, 'cant_read' ), 'set cant_read' );

ok( make_path($cant_read), 'create cant_read' );

ok( chmod(oct(0400), $cant_read), 'make cant_read unreadable' );

throws_ok{ _process_dirs($abs_tt2, $tmpl_vars, $abs_tmpl_path, $cant_read) } qr/\ACouldn't open directory/, 'process_files() fails on unreadable template path';

ok( remove_tree($cant_read), 'removing cant_read path' );

is( -d $cant_read, undef, 'cant_read path is removed' );

ok( _process_dirs($abs_tt2, $tmpl_vars, $abs_tmpl_path, $abs_tmpl_path), '_process_dirs() w/ absolute paths' );

ok( -d "$abs_output_path/bin", 'bin exists' );
ok( -d "$abs_output_path/lib", 'bin exists' );
ok( -d "$abs_output_path/t", 't exists' );
ok( -d "$abs_output_path/xt", 'xt exists' );
ok( -d "$abs_output_path/xt/author", 'xt/author exists' );
ok( -d "$abs_output_path/xt/release", 'xt/release exists' );

ok( -f "$abs_output_path/Changes", 'Changes exists' );
ok( -f "$abs_output_path/LICENSE", 'LICENSE exists' );
ok( -f "$abs_output_path/Makefile.PL", 'Makefile.PL exists' );
ok( -f "$abs_output_path/README", 'README exists' );
ok( -f "$abs_output_path/bin/app.pl", 'app.pl exists' );
ok( -f "$abs_output_path/lib/Module.pm", 'Module.pm exists' );
ok( -f "$abs_output_path/t/00-load.t", '00-load.t exists' );
ok( -f "$abs_output_path/xt/author/pod-coverage.t", 'pod-coverage.t exists' );
ok( -f "$abs_output_path/xt/author/critic.t", 'critic.t exists' );
ok( -f "$abs_output_path/xt/author/perlcritic.rc", 'perlcritic.rc exists' );
ok( -f "$abs_output_path/xt/release/pod-syntax.t", 'pod-syntax.t exists' );

ok( remove_tree($abs_output_path), 'removing output path' );

is( -d $abs_output_path, undef, 'output path is removed' );
