#!/bin/bash

export VERSION=5.10.0

. `dirname $0`/functions.sh

setup /usr/local/bin/perl
download http://www.cpan.org/src/perl-$VERSION.tar.gz
rm -rf perl-$VERSION
tar zxf perl-$VERSION.tar.gz
cd perl-$VERSION
sh Configure -des -Duseshrplib -Dperladmin=david@kineticode.com -Dcf_email=david@kineticode.com
make
make test
make install
