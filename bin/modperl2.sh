#!/bin/bash

export VERSION=2.0.4-rc1

. `dirname $0`/functions.sh

setup /usr/local/apache2/include/modperl_trace.h "MP_VERSION_STRING \"mod_perl/$VERSION\""
download http://www.apache.org/~gozer/mp2/mod_perl-$VERSION.tar.gz
#download http://perl.apache.org/dist/mod_perl-$VERSION.tar.gz
tar zxf mod_perl-$VERSION.tar.gz || exit $?
cd mod_perl-$VERSION
/usr/local/bin/perl Makefile.PL \
  MP_AP_PREFIX=/usr/local/apache2 \
  MP_PROMPT_DEFAULT=1 || exit $?
( make && make test && make install UNINST=1) || exit $?

# LoadModule perl_module modules/mod_perl.so