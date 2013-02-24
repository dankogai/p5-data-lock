#
# $Id: Makefile.PL,v 0.2 2013/02/24 07:03:27 dankogai Exp dankogai $
#
use 5.008001;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Attribute::Constant',
    AUTHOR              => 'Dan Kogai <dankogai+cpan@gmail.com>',
    VERSION_FROM        => 'lib/Attribute/Constant.pm',
    ABSTRACT_FROM       => 'lib/Attribute/Constant.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Attribute-Constant-*' },
);
