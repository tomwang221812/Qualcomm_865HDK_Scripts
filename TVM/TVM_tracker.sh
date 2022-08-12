#!/bin/sh

echo "(II) User Home Dir: $HOME"

export TVM_HOME="$HOME/tvm"
export PYTHONPATH=$TVM_HOME/python:${PYTHONPATH}

export TVM_TRACKER_HOST=$(hostname -I | cut -d' ' -f1)
export TVM_TRACKER_PORT=1100

python3 -m tvm.exec.rpc_tracker --host $TVM_TRACKER_HOST --port $TVM_TRACKER_PORT