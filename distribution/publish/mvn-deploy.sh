#!/bin/bash
# start this script by a Hudson shell script:

# chmod u+x ./distribution/publish/mvn-deploy.sh
# ./distribution/publish/mvn-deploy.sh

# for more info see 
#   https://wiki.eclipse.org/Services/Nexus#Deploying_artifacts_to_repo.eclipse.org
#   https://maven.apache.org/plugins/maven-deploy-plugin/deploy-file-mojo.html

set -x

BUILD_LOC=/home/data/httpd/download.eclipse.org/concierge
logFile=mvn-deploy.log

version=`cat version.txt`
echo "VERSION=$version"
if [[ "$version" == *-SNAPSHOT ]] ; then
  BUILD_LOC_TYPE=snapshots
else
  BUILD_LOC_TYPE=releases
fi
echo "BUILD_LOC_TYPE=$BUILD_LOC_TYPE"


if [ -d $BUILD_LOC/tmp ] ; then rm -rf $BUILD_LOC/tmp/* ; fi
if [ ! -d $BUILD_LOC/tmp ] ; then mkdir -p $BUILD_LOC/tmp ; fi

rm -f $BUILD_LOC/tmp/$logFile


(
# these files have to be uploaded to repo
ls -al ./distribution/build/repo/releases/org/eclipse/concierge/org.eclipse.concierge/1.0.0.SNAPSHOT/*.jar

mvn \
  -DgroupId=org.eclipse.concierge						\
  -DartifactId=org.eclipse.concierge					\
  -Dversion=1.0.0-SNAPSHOT								\
  -Dpackaging=jar										\
  -Dfile=./distribution/build/repo/releases/org/eclipse/concierge/org.eclipse.concierge/1.0.0.SNAPSHOT/org.eclipse.concierge-1.0.0.20150831.085350-1.jar	\
  -DrepositoryId=repo.eclipse.org						\
  -Durl=https://repo.eclipse.org/content/repositories/concierge-snapshots/	\
  deploy:deploy-file 

) >$BUILD_LOC/tmp/$logFile 2>&1


# cleanup
# if [ -d $BUILD_LOC/tmp ] ; then rm -rf $BUILD_LOC/tmp/* ; rmdir $BUILD_LOC/tmp ; fi
