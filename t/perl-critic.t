#!perl

#BEGIN {
#    unless ($ENV{AUTHOR_TESTING}) {
#        require Test::More;
#        Test::More::plan(
#            skip_all => 'these tests are for testing by the author'
#        );
#    }
#}

use strict;
use warnings;
use File::Spec;
use Test::More;
use English qw(-no-match-vars);

if ( not $ENV{AUTHOR_TESTING} ) {
    my $msg = "Author test. Set $ENV{AUTHOR_TESTING} to a true value to run.";
    plan( skip_all => $msg );
}

eval { require Test::Perl::Critic; };

if ( $EVAL_ERROR ) {
    my $msg = 'my message';
}

plan skip_all => 'Test::Perl::Critic required to criticise code' if $@;
Test::Perl::Critic->import( -profile => 'perlcritic.rc')
    if -e "perlcritic.rc";
all_critic_ok();
