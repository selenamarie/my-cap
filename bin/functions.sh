#!/bin/bash

OS=`uname`

# Pass the name of a file to check. If the file is found and there is no
# second argument, the script exits. If there is a second argument, its value
# is grepped for in the file named in the first argument. If it is found, the
# script exits. Otherwise, the script continues. If $FORCE is set to true, the
# script always continues. Continuation means that /usr/local/src is created
# and the pwd is changed to it.

setup() {
	if [ ! $FORCE ]; then
		if [ -f $1 ]; then
		    if [ -n "$2" ]; then
        	    if [ -n "`grep -l "$2" "$1"`" ]; then
        		    exit 0
        		fi
	        else
			    exit 0
		    fi
		fi
	fi

	mkdir -p /usr/local/src
	cd /usr/local/src
}

# Downloads the file from the URL passed as a single argument. If the file
# already exists and $FORCE is false, the function returns. Otherwise, it
# deletes any existing copy of the file and downloads it.

download() {
	file=`basename $1`
	if [ $FORCE ]; then
		rm -f $file
	fi

	if [ ! -f $file ]; then
        if [ $OS = 'Darwin' ]; then
		    curl -kO $1
		else
		    wget --no-check-certificate $1
	    fi
	fi
}

# Pass in the name of a download to have it built. The name should be the name
# of a tarball in the current pwd. The tarball can end in either .tar.gz or
# .tar.bz2. An existing decompressed directory will be deleted and the tarball
# decompressed. The function then cds into the directory and runs `./configure
# && make && make install`. If the directory created by the decompression is
# different than the name of the tarball, pass in that name as the second
# argument.
#
# Examples:
#  build aspell-1.2
#  build jpegsrc.v5.6 jpeg-5.6

build() {
	if [ $2 ]; then
		rm -rf $2
	else
		rm -rf $1
	fi

	if [ -f $1.tar.gz ]; then
		tar zxf $1.tar.gz
	elif [ -f $1.tar.bz2 ]; then
		tar jxf $1.tar.bz2
	fi

	if [ $2 ]; then
		cd $2
	else
		cd $1
	fi

	./configure
	make
	make install
	cd ..
}

