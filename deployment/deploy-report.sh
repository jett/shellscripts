#!/bin/sh

echo '*** deploying tfs-report to 130.130.2.192'
# connect and do our stuff
ssh -t -t tfs@130.130.2.192 << \EOL
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
echo 'performing backup for tfs-report.war ...'
cp --preserve=timestamps /opt/tfs/report/jetty/webapps/tfs-report.war ./backup/
echo 'performing backup for tfs-report.properties ...'
cp --preserve=timestamps /opt/tfs/report/jetty/resources/tfs-report.properties ./backup/
echo 'stopping the tfs-report service ...'
sudo service tfs-report stop
exit
EOL

echo 'copying new tfs-report.war ...'
scp tfs-report/target/tfs-report.war tfs@130.130.2.192:/opt/tfs/report/jetty/webapps/

echo 'starting tfs-report service'
ssh -t -t tfs@130.130.2.192 << \EOL
sudo service tfs-report start
exit
EOL
