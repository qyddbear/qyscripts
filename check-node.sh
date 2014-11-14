#! /bin/sh
set +ex
# Description: Sometimes there are something wrong with nodes, apps which locate on that node can't be accessed. This script is check which node is ok and which one is fail.
# Author qwang@redhat.com
# Date: 2014/11/14

function create_app()
{
  cd /home/qwang/test
  rhc app create rb18 ruby-1.8
}

function access_app()
{
  which_node
  export http_proxy=http://file.rdu.redhat.com:3128
  curl rb18-dstg.stg.rhcloud.com | grep "Welcome to OpenShift"
  sleep 5
  if [ "$?" -eq 0 ]
  then
    echo -e ${green}${hostname}"-->OK"${end}    
  else
    echo -e ${red}${hostname}"-->FAIL"${end}
  fi
}

function which_node()
{
  hostname=`rhc ssh rb18 --command hostname`
}

function delete_app()
{
  rhc app delete rb18 --confirm
}

function font_color()
{
  red="\033[0;31;1m"
  green="\033[0;32;1m" 
  end="\033[0m"
}


create_app
font_color
access_app
delete_app
