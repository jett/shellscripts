#!/bin/sh

echo '*** deploying tfs-core to 130.130.2.192'
# connect and do our stuff
ssh tfs@130.130.2.192 << \EOL
DATE=$(date +"%Y%m%d-%H%M")
cd /opt/tfs
if [ ! -d "deployment-hist" ]; then
  mkdir deployment-hist
fi
cd deployment-hist
if [ ! -d "$DATE" ]; then
  echo 'setting up folder for this deployment ...'
  mkdir $DATE
fi
cd $DATE
if [ ! -d "backup" ]; then
  echo 'creating backup folder ...'
  mkdir backup
fi
echo 'performing backup for tfs-core.war ...'
cp --preserve=timestamps /opt/tfs/core/jetty/webapps/tfs-core.war ./backup/
echo 'performing backup for tfs-core.properties ...'
cp --preserve=timestamps /opt/tfs/core/jetty/resources/tfs.properties ./backup/
echo 'stopping the tfs-core service ...'
sudo service tfs-core stop
exit
EOL

echo 'copying new tfs-core.war ...'
scp tfs/tfs-core/target/tfs-core.war tfs@130.130.2.192:/opt/tfs/core/jetty/webapps/

echo 'starting tfs-core service'
ssh -t -t tfs@130.130.2.192 << \EOL
sudo service tfs-core start
exit
EOL
