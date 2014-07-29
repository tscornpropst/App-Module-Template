use strict;
use warnings FATAL => 'all';
use Test::More;

BEGIN {
    unless ($ENV{AUTHOR_TESTING}) {
        require
    }
}

# Ensure a recent version of Test::Pod
my $min_tp = 1.22;
eval "use Test::Pod $min_tp";
plan skip_all => "Test::Pod $min_tp required for testing POD" if $@;

pod_file_ok( 'script/module-template', 'Valid POD file' );
