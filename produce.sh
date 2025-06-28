#!/bin/bash -x

# Compile to sources to the output
# It requires docker to be installed.
#
# The final web pages are in "output" and can be browsed

here=`dirname $0`
imagename="verifythis-www"

case "$1"
in

    inside*)
	cd $here
	owner=`stat -c "%U" $here`
	if [ $1 == "insideserver" ]
	then
		hugo server --bind 0.0.0.0 -d "$here/out"
	else
		hugo -d "$here/out"
	fi
        chown -R $owner:$owner "$here/out"
	;;

    *)
	if docker image ls $imagename | grep $imagename
	then
		echo "Image $imagename found!"
	else
		echo "Docker image not found. Run 'docker build -t $imagename .' in $here"
		exit 1
	fi
        mkdir -p "$here/out"
	if [ $1 == "server" ]
        then
		docker run -p 1313:1313 --rm -it -v "$here:/mnt" $imagename /mnt/produce.sh insideserver
	else
		docker run --rm -v "$here:/mnt" $imagename /mnt/produce.sh inside
	fi
	;;
esac

