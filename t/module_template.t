#!perl

use strict;
use warnings;

use Test::More tests => 25;
use Test::Exception;

use Cwd;
use File::HomeDir;
use File::Path qw/remove_tree/;

use_ok( 'App::Module::Template::Initialize', 'module_template' );

ok( my $mt_dir = join( q{/}, File::HomeDir->my_home(), '.module-template' ), 'set module-template dir' );

# skip if home path exists
SKIP: {
    skip( "$mt_dir exists", 2) if -d $mt_dir;

    ok( module_template(), 'module_template creates in home' );
    ok( remove_tree($mt_dir), 'remove test directory' );
}

ok( my $test_dir = join( q{/}, cwd, 'test_dir' ), 'set test dir' );

SKIP: {
    skip( "test doesn't exist", 1) unless -d $test_dir;
    ok( remove_tree($test_dir), 'remove test directory' );
}

ok( my $mt_test_dir = join( q{/}, $test_dir, '.module-template' ), 'set test module dir' );

is( module_template($test_dir), $mt_test_dir, 'module_template() w/ test dir' );

throws_ok{ module_template($test_dir) } qr/$mt_test_dir/, 'fails on existing directory';

ok( my $tmpl_dir = join( q{/}, $mt_test_dir, 'templates' ), 'set template dir' );

ok( -f "$mt_test_dir/config", 'config exists' );
ok( -f "$tmpl_dir/.gitignore", '.gitignore exists' );
ok( -f "$tmpl_dir/.travis.yml", '.travis.yml exists' );
ok( -f "$tmpl_dir/Changes", 'Changes exists' );
ok( -f "$tmpl_dir/LICENSE", 'LICENSE exists' );
ok( -f "$tmpl_dir/Makefile.PL", 'Makefile.PL exists' );
ok( -f "$tmpl_dir/README", 'README exists' );
ok( -f "$tmpl_dir/bin/script.pl", 'script.pl exists' );
ok( -f "$tmpl_dir/lib/Module.pm", 'Module.pm exists' );
ok( -f "$tmpl_dir/t/00-load.t", '00-load.t exists' );
ok( -f "$tmpl_dir/xt/author/critic.t", 'critic.t exists' );
ok( -f "$tmpl_dir/xt/author/perlcritic.rc", 'perlcritic.rc exists' );
ok( -f "$tmpl_dir/xt/author/pod-coverage.t", 'pod-coverage.t exists' );
ok( -f "$tmpl_dir/xt/release/pod-syntax.t", 'pod-syntax.t exists' );

SKIP: {
    skip( "test doesn't exist", 1) unless -d $test_dir;
    ok( remove_tree($test_dir), 'remove test directory' );
}
