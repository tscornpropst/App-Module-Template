package App::Module::Template;

use 5.016;

use strict;
use warnings;

our $VERSION = '0.01';

use base qw(Exporter);

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
use Try::Tiny;

our (@EXPORT_OK, %EXPORT_TAGS);
@EXPORT_OK = qw(
    get_module_dirs
    get_module_fqfn
    process_dirs
    process_file
    process_template
    prompt
    validate_module_name
);
%EXPORT_TAGS = (
    ALL => [ @EXPORT_OK ],
);

#-------------------------------------------------------------------------------
sub run {
    my $class = shift;

    my %opt;
    # -t template dir, location of template files
    # -c config file
    getopts('t:c:', \%opt);

    my $module   = $ARGV[0] || prompt();
    my $dist     = $module; $dist =~ s/::/-/gmsx;
    my $file     = $module; $file =~ s/.*:://msx; $file .= '.pm';
    my $dist_dir = File::Spec->catfile( cwd(), $dist );
    my $tmpl_vars;

    try {
        validate_module_name($module);
    } catch {
        say "$_\n\nmodule-template exiting...";
        exit();
    }

    my $template_dir;

    if (( exists $opt{t} ) and ( defined $opt{t} )) {
        $template_dir = $opt{t};
    }
    else {
        $template_dir  = join q{/}, File::HomeDir->my_home(), '.module-template/templates';

        #TODO
        # initialize template dir here
    }

    die "Template directory $template_dir does not exist\n"
        unless -d $template_dir;

    my $config_file;

    if ((exists $opt{c}) and (defined $opt{c} )) {
        $config_file = $opt{c};
    }
    else {
        $config_file = join q{/}, $template_dir, '/../config';
    }

    die "Could not locate configuration file $config_file\n"
        unless -f $config_file;

    my %cfg = Config::General->new(
            -ConfigFile            => $config_file,
            -MergeDuplicateBlocks  => 1,
            -MergeDuplicateOptions => 1,
            -AutoLaunder           => 1,
            -SplitPolicy           => 'equalsign',
            -InterPolateVars       => 1,
            -UTF8                  => 1,
    )->getall() or croak "could not read configuration file $config_file\n";

    my $output_path = join q{/}, cwd, $dist;

    # Setting this lets TT2 handle creating the destination files/directories
    $cfg{template_toolkit}{OUTPUT_PATH} = $output_path;

    my $tt2 = Template->new( $cfg{template_toolkit} )
        or croak Template->error();

    # don't need this in the $tmpl_vars
    delete $cfg{template_toolkit};

    # Template Vars
    $tmpl_vars = \%cfg;
    $tmpl_vars->{module} = $module;
    $tmpl_vars->{today} = strftime('%Y-%m-%d', localtime());
    $tmpl_vars->{year} = strftime('%Y', localtime());

    unless ( (defined $dist_dir) and (-d $dist_dir) ) {
        mkpath($dist_dir);
    }
    else {
        print "Destination directory $dist_dir exists\n";
        print "exiting...\n";
        exit();
    }

    process_dirs($tt2, $tmpl_vars, $template_dir, $template_dir);

    my $dirs = get_module_dirs( $module );

    # add the distribution dir to the front so our module ends up in the
    # right place
    unshift @{$dirs}, $dist_dir;

    my $fqfn = get_module_fqfn( $dirs, $file );

    # create the module directory
    mkpath( File::Spec->catdir( @{$dirs} ) );

    # rename the template file with the module file name
    move( File::Spec->catfile( $dist_dir, 'lib', 'Module.pm' ), $fqfn );

    return 1;
}

#-------------------------------------------------------------------------------
# Prompt the user for a module name if they omit from the command line
#-------------------------------------------------------------------------------
sub prompt {
    print 'module-template - Enter module name> ';

    my $line = <>;

    chomp $line;

    return $line;
}

#-------------------------------------------------------------------------------
# Validate the module naming convention
#
# 1. No top-level namespaces
# 2. No all lower case names
# 3. Match XXX::XXX
#-------------------------------------------------------------------------------
sub validate_module_name {
    my ($module_name) = @_;

    given ( $module_name ) {
        when ( $module_name =~ m/\A[A-Za-z]+\z/msx ) {
            croak "'$module_name' is a top-level namespace";
        }
        when ( $module_name =~ m/\A[a-z]+\:\:[a-z]+/msx ) {
            croak "'$module_name' is an all lower-case namespace";
        }
        # module name conforms
        when ( $module_name =~ m/\A[A-Z][A-Za-z]+(?:\:\:[A-Z][A-Za-z]+)+\z/msx ) {
            return 1;
        }
        default {
            croak "'$module_name' does not meet naming requirements";
        }
    }

    return;
}

#-------------------------------------------------------------------------------
# Split the module name into directories
#-------------------------------------------------------------------------------
sub get_module_dirs {
    my ($module) = @_;

    my @dirs = split( /::/msx, $module );

    # remove the last part of the module name because that will be the filename
    pop @dirs;

    unshift @dirs, 'lib';

    return \@dirs;
}

#-------------------------------------------------------------------------------
# Return the path to the fully qualified file name
#-------------------------------------------------------------------------------
sub get_module_fqfn {
    my ($dirs, $file_name) = @_;

    return File::Spec->catfile( @{$dirs}, $file_name );
}

#-------------------------------------------------------------------------------
# Walk the template directory
#-------------------------------------------------------------------------------
sub process_dirs {
    my ($tt2, $tmpl_vars, $template_dir, $source) = @_;

    if ( -d $source ) {
        my $dir;

        unless ( opendir $dir, $source ) {
            croak "Couldn't open directory $source: $!; skipping.\n";
        }

        while ( my $file = readdir $dir ) {
            next if $file eq '.' or $file eq '..';

            # File::Spec->catfile() is too helpful here, goin' old school
            my $target = "$source/$file";

            process_dirs($tt2, $tmpl_vars, $template_dir, $target);
        }

        closedir $dir;
    }
    else {
        my $output = process_file($template_dir, $source);

        process_template($tt2, $tmpl_vars, $source, $output);
    }

    return $source;
}

#-------------------------------------------------------------------------------
# Return the output path for TT2
#-------------------------------------------------------------------------------
sub process_file {
    my ($template_dir, $source_file) = @_;

    my ($stub) = $source_file =~ m{\A$template_dir/(.*)\z}mosx;

    return $stub;
}

#-------------------------------------------------------------------------------
sub process_template {
    my ($tt2, $tmpl_vars, $template, $output) = @_;

    $tt2->process($template, $tmpl_vars, $output) or croak $tt2->error();

    return $template;
}

1;

__END__

=pod

=head1 NAME

App::Module::Template - Perl module scaffolding with Template Toolkit

=head1 VERSION

This documentation refers to App::Module::Template version 0.01.

=head1 SYNOPSIS

    use App::Module::Template;

    App::Module::Template->run(@ARGS);

=head1 DESCRIPTION

App::Module::Template is the module loaded by 'module-template'. The subroutines were for the script were abstracted to this module for testing. See module-template for usage.

=head1 SUBROUTINES/METHODS

=over

=item C<run>

This function contains the main logic of the program. The script was abstracted here for testability.

=item C<get_module_dirs>

Return an array reference of directory parts from the module name.

=item C<get_module_fqfn>

Return the fully qualified file name for the module.

=item C<process_dirs>

Recursive function to walk the template directory and send templates to process_template().

=item C<process_file>

Return the output file path for use by process_template().

=item C<process_template>

Calls Template Toolkit to process the files in the module template directory.

=item C<prompt>

Displays a prompt when no module name is provided on the command line.

=item C<validate_module_name>

Validates input to ensure we have a valid Perl module name.

=back

=head1 EXAMPLES

None.

=head1 DIAGNOSTICS

=over

=item B<Couldn't open directory $directory_name $!; skipping.>

A directory in the module template is unreadable. Check permissions.

=item B<Template directory $template_dir does not exist>

The default template directory or the directory at the -t path does not exist.

=item B<Could not locate configuration file $config_file>

The default configuration file or the file at -c does not exist.

=back

=head1 CONFIGURATION AND ENVIRONMENT

App::Module::Template is configured by ~/.module-template/config.

=head1 DEPENDENCIES

=over

=item * Carp

=item * Config::General

=item * Cwd

=item * File::Basename

=item * File::Copy

=item * File::HomeDir

=item * File::Path

=item * File::Spec

=item * Getopt::Std

=item * POSIX

=item * Readonly

=item * Template

=item * Try::Tiny

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

