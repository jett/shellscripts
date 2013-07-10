#!/bin/bash

echo
echo 'downloading tfs-web source ... '
if [ ! -d "tfs-web" ]; then
        hg clone http://tfsbuilder:tfsbuilder@hg.incuventure.net/tfs-web
else
	echo 'updating tfs-web source ... '
        cd tfs-web
        hg pull http://tfsbuilder:tfsbuilder@hg.incuventure.net/tfs-web
	hg update
	cd ..
fi

cd tfs-web
grails war ./target/tfs-web.war
if [ "$?" -ne 0 ]; then
   echo 'tfs-web packaging failed!'
else
   echo 'tfs-web packaging success!'
fi
cd ..

