#
# $Id: Makefile.PL,v 0.1 2008/06/27 19:11:42 dankogai Exp dankogai $
#
use 5.008001;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Attribute::Constant',
    AUTHOR              => 'Dan Kogai <dankogai@dan.co.jp>',
    VERSION_FROM        => 'lib/Attribute/Constant.pm',
    ABSTRACT_FROM       => 'lib/Attribute/Constant.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Attribute-Constant-*' },
);
