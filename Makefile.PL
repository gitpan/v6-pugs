#!/usr/bin/perl

use strict;
use warnings;
my @inc;
BEGIN {
    @inc = (-e '../../inc' and -e '../../VICTUALS')
        ? (prefix => '../../inc')
        : (-e '../../../../inc' and -e '../../../../VICTUALS')
        ? (prefix => '../../../../inc')
        : ()
}
use lib '../..', (@inc ? $inc[-1] : ());
use inc::Module::Install @inc;

    name('v6-pugs');
all_from('lib/v6.pm');
requires('Pugs::Compiler::Rule' => '0.06');
requires('Module::Compile' => '0.16');
requires('Scalar::Util' => 0);
requires('Devel::Caller' => '0.09');
requires('Data::Bind' => '0.24');

recommends('Perl::Tidy' => 0);
recommends('Moose' => 0);

clean_files('t/*.tc', 't/*.pmc');

&WriteAll;

# Evil hack to add PERL6LIB path to Makefile
if (@inc) {
    system($^X, '-p', '-i.old', '-e', 's,PERL_DL_NONLAZY=1,PERL6LIB=../../ext/Test/lib,g', 'Makefile');
}
else {
    system($^X, '-p', '-i.old', '-e', 's,PERL_DL_NONLAZY=1,PERL6LIB=./t,g', 'Makefile');
}
