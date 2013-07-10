#!/bin/bash

rm -fR fordeploy/*

mkdir fordeploy

echo 'copying folders'

cp tfs fordeploy/ -r
cp tfs-web fordeploy/ -r
cp tfs-report fordeploy/ -r
cp dddcqrs fordeploy/ -r

cd fordeploy

cd tfs
mvn clean
rm -fR .hg
rm .hgignore
rm -fR target
cd ..

cd tfs-web
grails clean
rm -fR .hg
rm .hgignore
rm -fR target
rm stacktrace.log
cd ..

cd tfs-report
grails clean
rm -fR .hg
rm .hgignore
rm -fR target
rm stacktrace.log
cd ..

cd dddcqrs
mvn clean
rm -fR .hg
rm .hgignore
rm .hgtags
cd ..

echo 'ready!'
