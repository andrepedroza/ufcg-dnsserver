#!/bin/bash

if [ "$CLUSTER_MODE" == "2" ];then
  echo "master_ip = $MASTER_IP" >> /nxfilter/conf/cfg.properties
else
  export CLUSTER_MODE=1
fi

echo "cluster_mode = $CLUSTER_MODE" >> /nxfilter/conf/cfg.properties

supervisord
