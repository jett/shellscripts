#!/bin/sh

echo '*** deploying tfs-web to 130.130.2.190'
# connect and do our stuff
ssh tfs@130.130.2.190 << \EOL
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
echo 'performing backup for tfs-web.war ...'
cp --preserve=timestamps /opt/tfs/web/jetty/webapps/tfs-web.war ./backup/
echo 'performing backup for tfs-web.properties ...'
cp --preserve=timestamps /opt/tfs/web/jetty/resources/tfs-web.properties ./backup/
echo 'stopping the tfs-web service ...'
sudo service tfs-web stop
exit
EOL

echo 'copying new tfs-web.war ...'
scp tfs-web/target/tfs-web.war tfs@130.130.2.190:/opt/tfs/web/jetty/webapps/

echo 'starting tfs-web service'
ssh -t -t tfs@130.130.2.190 << \EOL
sudo service tfs-web start
exit
EOL
