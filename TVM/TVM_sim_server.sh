#!/bin/sh

echo "(II) User Home Dir: $HOME"

export TVM_HOME="$HOME/tvm"
export PYTHONPATH=$TVM_HOME/python:${PYTHONPATH}

export TVM_TRACKER_HOST=$(hostname -I | cut -d' ' -f1)
export TVM_TRACKER_PORT=1100

export TVM_SERVER_HOST=$(hostname -I | cut -d' ' -f1)
export TVM_SERVER_PORT=1101

$TVM_HOME/build/hexagon_api_output/tvm_rpc_x86 server --host=${TVM_SERVER_HOST} --port=${TVM_SERVER_PORT} --tracker=${TVM_TRACKER_HOST}:${TVM_TRACKER_PORT} --key=hexagon-simulator