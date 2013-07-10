#!/bin/bash

echo 'clearing .m2 and .ivy-cache ...'
rm -rf ~/.grails/ivy-cache/com.ucpb
rm -rf ~/.grails/ivy-cache/com.incuventure

echo
if [ ! -d "dddcqrs" ]; then
	echo 'downloading ddd-crqrs source ... '
	hg clone http://tfsbuilder:tfsbuilder@hg.incuventure.net/dddcqrs
else
	echo 'updating ddd-crqrs source ... '
	cd dddcqrs
	hg pull http://tfsbuilder:tfsbuilder@hg.incuventure.net/dddcqrs
	hg update
	cd ..
fi

cd dddcqrs
mvn -q clean install -DskipTests
if [ [ $? -ne 0 ] ] ; then
   echo 'dddcqrs build failed!'
else
   echo 'dddcqrs build success!'
fi

cd ..

echo
if [ ! -d "tfs" ]; then
	echo 'downloading tfs source ... '
	hg clone http://tfsbuilder:tfsbuilder@hg.incuventure.net/tfs
else
	echo 'updating tfs source ... '
        cd tfs
        hg pull http://tfsbuilder:tfsbuilder@hg.incuventure.net/tfs
	hg update
	cd ..
fi

cd tfs
cd tfs-swift
mvn -q clean install -DskipTests
if [ "$?" -ne 0 ]; then
   echo 'tfs-swift build failed!'
else
   echo 'tfs-swift build success!'
fi
cd ..
cd tfs-interfaces
mvn -q clean install -P deployment -DskipTests
if [ "$?" -ne 0 ]; then
   echo 'tfs-interfaces build failed!'
else
   echo 'tfs-interfaces build success!'
fi
cd ..
cd tfs-batch
mvn -q clean install -DskipTests
if [ "$?" -ne 0 ]; then
   echo 'tfs-batch build failed!'
else
   echo 'tfs-batch build success!'
fi
cd ..
cd tfs-app
mvn -q clean install -DskipTests
if [ "$?" -ne 0 ]; then
   echo 'tfs-batch build failed!'
else
   echo 'tfs-batch build success!'
fi
cd ..
cd tfs-core
mvn -q clean package -DskipTests
if [ "$?" -ne 0 ]; then
   echo 'tfs-core build and package failed!'
else
   echo 'tfs-core build and package success!'
fi
cd ..
cd ..
