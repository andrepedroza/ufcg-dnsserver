#!/bin/bash

if [ "$CLUSTER_MODE" == "2" ];then
  echo "master_ip = $MASTER_IP" >> /nxfilter/conf/cfg.properties
else
  export CLUSTER_MODE=1
fi

if grep -Fxq "cluster_mode" /nxfilter/conf/cfg.properties;then
  echo "Cluster mode found, skip..."
else
  echo "Settting up Cluster mode to $CLUSTER_MODE"
  echo "cluster_mode = $CLUSTER_MODE" >> /nxfilter/conf/cfg.properties
fi

if [ -e /nxfilter/conf/uid.txt ]; then
  echo "Files found, skip..."
else
  echo "First boot, coping default files..."
  cp -R /nxfilter/default/* /nxfilter/
fi

supervisord
