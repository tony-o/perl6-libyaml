#! /usr/bin/env perl6
#Note `zef build .` will run this script
use v6;

class Build {
    need LibraryMake;
    # adapted from deprecated Native::Resources

    #| Sets up a C<Makefile> and runs C<make>.  C<$folder> should be
    #| C<"$folder/resources/lib"> and C<$libname> should be the name of the library
    #| without any prefixes or extensions.
    sub make(Str $folder, Str $destfolder, :$libname) {
        my %vars = LibraryMake::get-vars($destfolder);

        mkdir($destfolder);
        LibraryMake::process-makefile($folder, %vars);
        shell(%vars<MAKE>);

        my @fake-lib-exts = <.so .dll .dylib>.grep(* ne %vars<SO>);
        "$destfolder/$libname$_".IO.open(:w) for @fake-lib-exts;
    }

    method build($workdir) {
        my $destdir = 'resources/lib';
        mkdir $destdir;
        make($workdir, "$destdir", :libname<libyamlwrap>);
    }
}

# Build.pm can also be run standalone
sub MAIN(Str $working-directory = '.' ) {
    Build.new.build($working-directory);
    exit 0;
}
