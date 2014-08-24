#!perl

use strict;
use warnings FATAL => 'all';

use Test::More tests => 6;

use Capture::Tiny qw/capture/;
use File::Path qw/remove_tree/;
use File::Spec;
use File::Temp qw/tempfile/;

@ARGV = (
    '-t',
    File::Spec->abs2rel( File::Spec->catdir( File::Spec->curdir, 't', '.module-template', 'templates' ) ),
    '-c',
    File::Spec->abs2rel( File::Spec->catfile( File::Spec->curdir, 't', '.module-template', 'config' ) ),
);

use_ok( 'App::Module::Template', 'run' );

# test code taken from David Golden's IO::Prompt::Tiny
sub _set_tempfile {
  my $text = shift;
  my $temp = tempfile;
  select $temp; local $|=1; select STDOUT;
  print {$temp} $text;
  seek $temp, 0, 0;
  return $temp;
}

sub _prompt {
    my (@args) = @_;
    my $result = capture { scalar run(@args) };
}

ok( my $module_path = File::Spec->catdir( File::Spec->curdir, 'Some-Test' ), 'set module path' );

SKIP: {
    skip( 'module path does not exist', 1 ) unless -d $module_path;
    ok( remove_tree($module_path), 'remove module path' );
}

{
    no warnings 'redefine';
    local *IO::Prompt::Tiny::_is_interactive = sub { 1 }; # fake it for testing
    local *STDIN = _set_tempfile('Some::Test');
    ok( _prompt(@ARGV), 'run w/o module name prompts' );
};

ok( -d $module_path, 'module path exists' );
ok( remove_tree($module_path), 'remove module path' );
