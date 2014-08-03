package App::Module::Template::Initialize;

use 5.016;

use strict;
use warnings;

our $VERSION = '0.01';

use Carp;

our (@EXPORT_OK, %EXPORT_TAGS);

@EXPORT_OK = qw(); # on demand
%EXPORT_TAGS = (
    ALL => [ @EXPORT_OK ],
);

our $TEMPLATES = {
    gitignore => {
        filename => '.gitignore',
        path => '.module-template/templates',
        body => <<'END_OF_BODY',
END_OF_BODY
    },
    makefile_pl => {
        filename => 'Makefile.PL',
        path => '.module-template/templates',
        body => <<'END_OF_BODY',
END_OF_BODY
    },
    license => {
        filename => 'LICENSE',
        path => '.module-template/templates',
        body => <<'END_OF_BODY',
END_OF_BODY
    },
    changes => {
        filename => 'Changes',
        path => '.module-template/templates',
        body => <<'END_OF_BODY',
END_OF_BODY
    },
    readme => {
        filename => 'README',
        path => '.module-template/templates',
        body => <<'END_OF_BODY',
END_OF_BODY
    },
    script => {
        filename => 'script.pl',
        path => '.module-template/templates',
        body => <<'END_OF_BODY',
END_OF_BODY
    },
    module => {
        filename => 'Module.pm',
        path => '.module-template/templates',
        body => <<'END_OF_BODY',
END_OF_BODY
    },
    load_test => {
        filename => '00-load.t',
        path => '.module-template/templates',
        body => <<'END_OF_BODY',
END_OF_BODY
    },
    critic_test => {
        filename => 'critic.t',
        path => '.module-template/templates',
        body => <<'END_OF_BODY',
END_OF_BODY
    },
    critic_rc => {
        filename => 'perlcritic.rc',
        path => '.module-template/templates',
        body => <<'END_OF_BODY',
END_OF_BODY
    },
    pod_coverage_test => {
        filename => 'pod-coverage.t',
        path => '.module-template/templates',
        body => <<'END_OF_BODY',
END_OF_BODY
    },
    pod_syntax_test => {
        filename => 'pod-syntax.t',
        path => '.module-template/templates',
        body => <<'END_OF_BODY',
END_OF_BODY
    }
};

#-------------------------------------------------------------------------------
sub get_template_filename {
}

#-------------------------------------------------------------------------------
sub get_template_path {

}

#-------------------------------------------------------------------------------
sub get_template_body {

}

#-------------------------------------------------------------------------------
sub write_template_file {

}

#-------------------------------------------------------------------------------
sub make_directory {
}

1;

__END__

=pod

=head1 NAME

App::Module::Template::Initialize - Templates to pre-populate template directory

=head1 VERSION

This documentation refers to App::Module::Template::Initialize version 0.01.

=head1 SYNOPSIS

    use App::Module::Template::Initialize;

=head1 DESCRIPTION

=head1 SUBROUTINES/METHODS

=over

=item C<get_template_filename>

=item C<get_template_path>

=item C<get_template_body>

=item C<write_template_file>

=item C<make_directory>

=back

=head1 EXAMPLES

None.

=head1 DIAGNOSTICS

=over

=item B<Error Message>

=back

=head1 CONFIGURATION AND ENVIRONMENT

None.

=head1 DEPENDENCIES

=over

=item * Carp

=back

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any issues or feature requests to Trevor S. Cornpropst C<tscornpropst@gmail.com>. Patches are welcome.

=head1 AUTHOR

Trevor S. Cornpropst

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2014 Trevor S. Cornpropst C<< tscornpropst@gmail.com >>. All rights reserved.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=cut

