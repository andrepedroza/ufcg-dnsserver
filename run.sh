#!/bin/bash

# Fix Volume bind
if [ -e /nxfilter/conf/cfg.default ]; then
  echo "File found, skip..."
else
  echo "First boot, coping default files..."
  cp -R /nxfilter/conf.default/* /nxfilter/conf/
fi

#Verify Cluster Mode
if [ "$CLUSTER_MODE" == "2" ];then
  echo "master_ip = $MASTER_IP" >> /nxfilter/conf/cfg.properties
else
  export CLUSTER_MODE=1
fi

#Change Cluster Mode If Needed
sed -i -e "s/cluster_mode = 0/cluster_mode = $CLUSTER_MODE/g" /nxfilter/conf/cfg.properties

#Update Shallalist
/nxfilter/bin/update-sh.sh

#Start NxFilter
/nxfilter/bin/startup.sh
