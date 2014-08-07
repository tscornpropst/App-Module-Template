use strict;
use warnings;

use 5.016;

use ExtUtils::MakeMaker 6.63;

my %WriteMakefileArgs = (
    NAME                  => 'App::Module::Template',
    AUTHOR                => 'Trevor S. Cornpropst <tscornpropst@gmail.com>',
    VERSION_FROM          => 'lib/App/Module/Template.pm',
    ABSTRACT_FROM         => 'lib/App/Module/Template.pm',
    LICENSE               => 'artistic2',
    DISTNAME              => 'App-Module-Template',
    MIN_PERL_VERSION      => 5.016,
    BUILD_REQUIRES        => {
        'ExtUtils::MakeMaker' => 6.63,
    },
    CONFIGURE_REQUIRES    => {
        'ExtUtils::MakeMaker' => 6.63,
    },
    PREREQ_PM             => {
        'Carp'            => 0,
        'Config::General' => 0,
        'Cwd'             => 0,
        'File::Basename'  => 0,
        'File::Copy'      => 0,
        'File::HomeDir'   => 0,
        'File::Path'      => 0,
        'File::Spec'      => 0,
        'Getopt::Std'     => 0,
        'POSIX'           => 0,
        'Readonly'        => 0,
        'Template'        => 0,
        'Try::Tiny'       => 0,
    },
    TEST_REQUIRES         => {
        'Test::More'      => 0,
        'Test::Exception' => 0
    },
    EXE_FILES             => ['bin/module-template'],
    dist                  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    test                  => { TESTS => "t/*.t" },
);

my %FallbackPrereqs = (
    'Carp'            => 0,
    'Config::General' => 0,
    'Cwd'             => 0,
    'File::Basename'  => 0,
    'File::Copy'      => 0,
    'File::HomeDir'   => 0,
    'File::Path'      => 0,
    'File::Spec'      => 0,
    'Getopt::Std'     => 0,
    'POSIX'           => 0,
    'Readonly'        => 0,
    'Template'        => 0,
    'Try::Tiny'       => 0,
);

unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
    delete $WriteMakefileArgs{TEST_REQUIRES};
    delete $WriteMakefileArgs{BUILD_REQUIRES};
    $WriteMakefileArgs{PREREQ_PM} = \%FallbackPrereqs;
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
    unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);
