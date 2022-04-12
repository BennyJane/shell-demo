#!/bin/bash

set -e

cd $(dirname "$0")
echo "[当前目录]： $(pwd)"

removeUnusedImages() {
  docker rmi $(docker images | grep "none" | awk 'print $3')
}

removeUnusedContainer() {
  docker stop $(docker ps -a | grep "Exited" | awk '{print $1}')
  docker rm $(docker ps -a | grep "Exited" | awk '{print $1}')
}

main() {
  while :; do
    echo '---------------------------------[主目录]--------------------------------------------'
    echo "请输入想进行的操作：(rmi|rm|llc|li|exit)"
    read command
    case ${command} in
    "rmi")
      removeUnusedImages
      ;;
    "rm")
      removeUnusedContainer
      ;;
    "llc")
      docker ps -a
      ;;
    "li")
      docker images
      ;;
    "exit")
      exit 1
      ;;
    *)
      echo "没暂时没有该命令"
      ;;
    esac
  done
}

main
