#!/bin/sh

export TAG=REL9_1_BETA2
export PERL=/usr/local/bin/perl
export BASE=/opt/pgsql-$TAG

cd ~/proj/repos/postgresql
if [ -f GNUmakefile ]; then
    make maintainer-clean
fi
git checkout $TAG
git pull
sudo rm -rf $BASE
# Add  --enable-cassert --enable-debug for debugging.
./configure --with-libs=/usr/local/lib  --with-libs=/usr/lib --with-libs=/usr/local/Cellar --with-includes=/usr/local/include --prefix=$BASE --with-python --with-ossp-uuid --with-perl PERL=$PERL || exit $?
make -j3 || exit $?
sudo make install || exit $?

# Install contrib modules
cd contrib
make -j3 || exit $?
sudo make install || exit $?
make clean
cd ..

sudo mkdir $BASE/data || exit $?
sudo chown -R postgres $BASE/data || exit $?
sudo -u postgres $BASE/bin/initdb --locale en_US.UTF-8 --encoding utf-8 -D $BASE/data || exit $?
sudo mkdir $BASE/data/logs
sudo chown -R postgres $BASE/data/logs
