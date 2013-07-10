#!/bin/bash

echo
if [ ! -d "tfs-report" ]; then
	echo 'downloading tfs-report source ... '
  hg clone http://tfsbuilder:tfsbuilder@hg.incuventure.net/tfs-report
else
	echo 'updating tfs-report source ... '
        cd tfs-report
hg pull http://tfsbuilder:tfsbuilder@hg.incuventure.net/tfs-report
	hg update
	cd ..
fi
cd tfs-report
# grails war ./target/tfs-report war
grails war target/tfs-report.war
if [ "$?" -ne 0 ]; then
   echo 'tfs-report packaging failed!'
else
   echo 'tfs-report packaging success!'
fi
cd ..

