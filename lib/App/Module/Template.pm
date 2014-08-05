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
use Readonly;
use Template;
use Try::Tiny;

Readonly::Scalar my $MAX_ARGS => 3;

our (@EXPORT_OK, %EXPORT_TAGS);
@EXPORT_OK = qw(
    validate_module_name
);
%EXPORT_TAGS = (
    ALL => [ @EXPORT_OK ],
);

my $cwd;
my $tt2;
my $tmpl_vars;

#-------------------------------------------------------------------------------
sub run {
    my $class = shift;

    my %opt;
    # -t template dir, location of template files
    # -c config file
    getopts('t:c:', \%opt);

    my $module = $ARGV[0] || prompt();
    my $dist   = $module; $dist =~ s/::/-/gmsx;
    my $file   = $module; $file =~ s/.*:://msx; $file .= '.pm';
    $cwd       = File::Spec->catfile( cwd(), $dist );

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

    my $tt_conf = $cfg{template_toolkit};

    delete $cfg{template_toolkit};

    $tt2 = Template->new( $tt_conf ) or croak Template->error();

    # Template Vars
    $tmpl_vars = \%cfg;
    $tmpl_vars->{module} = $module;
    $tmpl_vars->{today} = strftime('%Y-%m-%d', localtime());
    $tmpl_vars->{year} = strftime('%Y', localtime());

    unless ( (defined $cwd) and (-d $cwd) ) {
        mkpath($cwd);

    if ( -d $cwd ) {
        chdir $cwd;
    }
    else {
        croak "Could not chdir to $cwd\n";
    }
    }
    else {
        print "Destination directory $cwd exists\n";
        print "exiting...\n";
        exit();
    }

    dir_walk($template_dir, \&process_files, \&process_dirs);

    fix_module_path($module, $file);

    return 1;
}

#-------------------------------------------------------------------------------
# Fixup the module filename and path.
#-------------------------------------------------------------------------------
sub fix_module_path {
    my ($module, $file) = @_;

    my @dirs = split( /::/msx, $module );

    # remove the last part of the module name because that will be the filename
    pop @dirs;

    unshift @dirs, 'lib';

    mkpath( File::Spec->catdir( @dirs ) );

    my $dest_file = File::Spec->catfile( @dirs, $file );

    move( File::Spec->catfile( 'lib', 'Module.pm' ), $dest_file );

    return $dest_file;
}

#-------------------------------------------------------------------------------
# callback to pass to dir_walk to handle files
#-------------------------------------------------------------------------------
sub process_files {
    my ($src_file) = @_;

    # grab the directory name to be handled by dir_sub()
    # This also ensures the directory exists before we write the file
    my ($template, $src_directory, $suffix) =
        fileparse($src_file, qr/[.]{1,1}swp\z/msx);

    # skip swap files
    return if $suffix eq '.swp';

    # call process_dirs() to create the destination directory
    my $dest_dir = process_dirs($src_directory);

    # $dest_dir will be undef if it is the parent template directory so,
    # we set it to the current working directory
    $dest_dir = $cwd unless defined $dest_dir;

    my $dest_file = join q{/}, $dest_dir, $template;

    # process the template and write the output
    process_template($src_file, $tmpl_vars, $dest_file);

    return;
}

#-------------------------------------------------------------------------------
# callback to pass to dir_walk() to handle directories
#
# Create destination directories that do not exist
#-------------------------------------------------------------------------------
sub process_dirs {
    my ($src_dir) = @_;

    my $stub = basename($src_dir);

    # return undef here so we don't re-create the templates top-level dir
    # file_sub() will fix the path
    return if $stub eq 'templates';
    return if $stub eq '.module-template';

    my $dest_dir = join q{/}, $cwd, $stub;

    unless ( -d $dest_dir ) {
        mkpath($dest_dir);
    }

    return $dest_dir;
}

#-------------------------------------------------------------------------------
# Prompt the user for a module name if they omit from the command line
#-------------------------------------------------------------------------------
sub prompt {
    print 'module-template - Module Name> ';

    my $line = <STDIN>;

    chomp $line;

    return $line;
}

#-------------------------------------------------------------------------------
# Recursive currying function to walk a directory of files.
#
# Thanks MJD for Higher-Order Perl!
#-------------------------------------------------------------------------------
sub dir_walk {
    unshift @_, undef if @_ < $MAX_ARGS;

    my ($top, $filefunc, $dirfunc) = @_;

    my $r;

    $r = sub {
        my $DIR;
        my $top = shift;

        if ( -d $top ) {
            my $file;

            unless (opendir $DIR, $top) {
                carp "Couldn't open directory $top $!; skipping.\n";
                return;
            }

            my @results;

            while ($file = readdir $DIR) {
                next if $file eq '.' || $file eq '..';
                push @results, $r->("$top/$file");
            }

            return $dirfunc->($top, @results);
        }
        else {
            return $filefunc->($top);
        }
    };

    return defined($top) ? $r->($top) : $r;
}

#-------------------------------------------------------------------------------
# $tt2->process($template, $tmpl_vars, $output);
#-------------------------------------------------------------------------------
sub process_template {
    my (@args) = @_;

    $tt2->process(@args) or croak $tt2->error();

    return;
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

=item C<dir_walk>

Recursive function to process all files in the module template directory.

=item C<fix_module_path>

Fixes module path to match the module naming convention.

=item C<process_dirs>

Function passed to dir_walk() to handle directories.

=item C<process_files>

Function passed to dir_walk() to handle files.

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

=item B<Couldn't open directory $top $!; skipping.>

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

