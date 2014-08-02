package main;

require 5.008008;
use strict;
use warnings FATAL => 'all';

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => '[% module %]',
    AUTHOR              => q{[% author %] [% email %]},
    VERSION_FROM        => '[% module_path %]',
    ABSTRACT_FROM       => '[% module_path %]',
    LICENSE             => '[% license_type %]',
    BUILD_REQUIRES      => {},
    MIN_PERL_VERSION    => 5.006,
    CONFIGURE_REQUIRES  => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES      => {
        'Test::More'    => 0,
    },
    PREREQ_PM           => {
        #'Some::Module' => 1.23,
    },
    DISTNAME => '[% dist %]',
    test => {
        "TESTS" => "t/*.t",
    },
    dist => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => '-*' },
);
