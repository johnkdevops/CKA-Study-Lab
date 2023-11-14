#!/bin/bash

# Declare variables
MAIN_CTL_PLANE_IP=172.31.20.65

errorExit() {
  echo "*** $@" 1>&2
  exit 1
}

curl --silent --max-time 2 --insecure https://localhost:6443/ -o /dev/null || errorExit "Error GET https://localhost:6443/"
if ip addr | grep -q 172.31.31.100; then
  curl --silent --max-time 2 --insecure https://${MAIN_CTL_PLANE_IP}:6443/ -o /dev/null || errorExit "Error GET https://${MAIN_CTL_PLANE_IP}:6443/"
fi

