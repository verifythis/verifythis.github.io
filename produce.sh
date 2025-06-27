#!/bin/bash -x

# Compile to sources to the output
# It requires docker to be installed.
#
# The final web pages are in "output" and can be browsed

here=`dirname $0`
imagename="verifythis-www"

case "$1"
in

  inside)
	cd $here
	hugo -d out
	owner=`stat -c "%U" $here`
	chown -R "$owner":"$owner" $here/out
	;;

  insideserver)
	cd $here
	hugo server --bind 0.0.0.0
	;;

  *)
	if docker image ls $imagename | grep $imagename
	then
		echo "Image $imagename found!"
	else
		echo "Docker image not found. Run 'docker build -t $imagename .' in $here"
		exit 1
	fi
	docker run -p 1313:1313 --rm -v "$here:/mnt" $imagename /mnt/produce.sh inside$1
	;;
esac

