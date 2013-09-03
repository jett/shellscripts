#!/bin/bash
#title            :  build-ims-latest.sh
#description : This script downloads lastest version of artifacts from the IPC hg repository and builds them
#author	     : jett gamboa
#version        : 0.1    

#echo 'clearing .m2 ...'
#rm -rf ~/.m2/repository/com/ucpb/common-domain
#rm -rf ~/.m2/repository/com/ucpb/event-domain
#rm -rf ~/.m2/repository/com/ucpb/ims-domain

read -p "userid: " hguser
read -s -p "password: " hgpwd


pullAndBuild() {

	artifact=$1
	artifactPath=$2
	fullPath="$artifactPath/$artifact"
	repositoryUrl="vcs.incuventure.net"
	mvnaction=$3
	error=0
	
	fullPath="http://$hguser:$hgpwd@$repositoryUrl/$fullPath"
	
	echo
	echo -e "\e[1;33mbuilding artifact " "$artifactPath/$artifact \e[0;37m"

	if [ ! -d "$artifact" ]; then
		echo "downloading $artifact source ... "
		hg clone $fullPath
		
		if [ $? -ne 0 ] ; then
			error=1
		fi
	else
		echo "updating $artifact source ... "
		
		cd $artifact
		hg pull $fullPath
		
		if [ $? -eq 0 ] ; then
			hg update
		else
			error=1
		fi
		
		cd ..
	fi
	
	if [ $error -eq 1 ]; then
		echo "error pulling $artifact from repository, will not $mvnaction"
	else
		echo "$mvnaction $artifact"
		
		cd $artifact
		mvn -q clean $mvnaction -DskipTests | egrep "(^\[ERROR\])"
		if [ "$PIPESTATUS" != "0" ] ; then
		   echo -e "\e[1;31m$artifact $mvnaction failed!" "\e[0;37m"
		else
		   echo -e "\e[1;32m$artifact $mvnaction success!" "\e[0;37m"
		fi

		cd ..
	fi
}

pullAndBuild common-domain tbs/tbs-domain install
pullAndBuild ims-domain tbs/tbs-domain install