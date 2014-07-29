package App::Module::Template;

use 5.016;
use strict;
use warnings;

use Carp;
use Config::General;
use Cwd;
use File::Basename;
use File::Copy;
use File::HomeDir;
use File::Path;
use File::Spec;
use Getopt::Std;
use POSIX qw(strftime);
use Template;

sub run {
    my $class = shift;

    my %opt;

    getopts('t:c:', \%opt);

    my $module = $ARGV[0] || print "huh?\n";

#my $module   = $ARGV[0] || prompt();
my $dist     = $module; $dist =~ s/::/-/g;
my $file     = $module; $file =~ s/.*:://; $file .= ".pm";
my $cwd      = File::Spec->catfile( cwd(), $dist );

my ($r, $msg) = validate_module_name($module);

unless ( $r ) {
    say "$msg; exiting...";
    exit();
}

my $template_dir;

if (( exists $opt{t} ) and ( defined $opt{t} )) {
    $template_dir = $opt{t};
}
else {
    $template_dir  = join q{/}, File::HomeDir->my_home(), '.module-template/temp
lates';
}

die "Template directory $template_dir does not exist\n"
    unless -d $template_dir;

my $config_file;

if ((exists $opt{c}) and (defined $opt{c} )) {
    $config_file = $opt{c};
}
else {
    $config_file = join q{/}, $template_dir, '/config';
}

die "Could not locate configuration file $config_file\n"
    unless -f $config_file;

#    my $count = 1;
#
#    foreach my $arg ( @ARGV ) {
#        print "ARG $count: $arg\n";
#    }

    return 1;
}
#use version; our $VERSION = qv('0.0.1');
#
#use Carp;
#use Params::Validate qw(:all);
#use POSIX qw(strftime);
#
#our (@EXPORT_OK, %EXPORT_TAGS);
#
#@EXPORT_OK = qw(); # on demand
#%EXPORT_TAGS = (
#    ALL => [ @EXPORT_OK ],
#);
#
##-------------------------------------------------------------------------------
#sub new {
#    my ($class, $args) = @_;
#
#    my $self = bless {}, $class;
#
#    $self->_init($args);
#
#    return $self;
#}
#
##-------------------------------------------------------------------------------
#sub _init {
#    my $self = shift;
#
#    my $p = validate(
#        @_, {
#            value1 => { optional => 1 },
#            value2 => { optional => 1 },
#        },
#    );
#
##    $self->SUPER::_init($p);
#
#    return;
#}

1;


