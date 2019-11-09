#!/bin/sh
# [使い方]
# 例) sh allExec.sh "ls | grep log"

cmd=$1
#cmd='ls /html/www | grep "sample.log"'
if [ -z "$1" ]; then
  exit
fi

# /etc/hosts のリストから読み取って実行する
for server in `cat /etc/hosts | awk '{print $3}' | grep -oP "ne[0-9]{1,2}" | sort | uniq `
do
  echo -e "\e[1;32m$server\e[m"
  ssh $server "$cmd"
done
