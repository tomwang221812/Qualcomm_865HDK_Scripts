#!/bin/bash

export TVM_ROOT=$HOME/Qualcomm/TVM_Tools/1.4
export TVM_ROOT_DIR=$TVM_ROOT
export TVM_EXAMPLE=$TVM_ROOT/tvm-examples

echo "Enter the sudo password: "
read PW

echo $PW | sudo apt -y install libopenblas-dev python3.8 python3-pip python-is-python3
python3 -m pip install numpy scipy tornado libxml2-dev libtinfo-dev pytest

export HEXAGON_SDK_VERSION='4.5.0.3'
export HEXAGON_TOOLCHAIN_VERSION='8.5.08'

export HEXAGON_SDK="$HOME/Qualcomm/Hexagon_SDK/$HEXAGON_SDK_VERSION"

export PYTHONPATH=${TVM_ROOT}/tvm-python/python:${TVM_ROOT}/tvm-python/topi/python:${TVM_ROOT}/tvm-examples:${PYTHONPATH}
export LD_LIBRARY_PATH=${TVM_ROOT}/lib/x86_64:$HOME/Qualcomm/Hexagon_SDK/$HEXAGON_SDK_VERSION/tools/HEXAGON_Tools/$HEXAGON_TOOLCHAIN_VERSION/Tools/lib/iss:${LD_LIBRARY_PATH}
export ADSP_LIBRARY_PATH=${TVM_ROOT}/lib/hexagon
export PATH=${TVM_ROOT}/bin/hexagon/v66:$HOME/Qualcomm/Hexagon_SDK/$HEXAGON_SDK_VERSION/tools/HEXAGON_Tools/$HEXAGON_TOOLCHAIN_VERSION/Tools/bin:${PATH}
export HEXAGON_TOOLCHAIN=$HOME/Qualcomm/Hexagon_SDK/$HEXAGON_SDK_VERSION/tools/HEXAGON_Tools/$HEXAGON_TOOLCHAIN_VERSION/Tools

# Setup Android NDK Environment
export ANDROID_NDK_VERSION='25.0.8775105'
export ANDROID_NDK_ROOT="$HOME/Android/Sdk/ndk/$ANDROID_NDK_VERSION"
export ANDROID_NDK="$ANDROID_NDK_ROOT/build/cmake/android.toolchain.cmake"
export TVM_NDK_CC=${ANDROID_NDK_ROOT}/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android26-clang++

# TVM RPC
export TVM_TRACKER_HOST=$(hostname -I | cut -d' ' -f1)
export TVM_TRACKER_PORT=9190

# Upload TVM app and lib
adb wait-for-device root
adb disable-verity
adb reboot
adb wait-for-device root
adb remount

# Sig the device
cd $HEXAGON_SDK
$HEXAGON_SDK/setup_sdk_env.source
python3 $HOME/Qualcomm/Hexagon_SDK/4.5.0.3/utils/scripts/signer.py sign

cd ${TVM_ROOT}
# adb install -r ${TVM_ROOT}/app/tvmrpc-release.apk
adb push ${TVM_ROOT}/lib/hexagon/v66/libtvm_remote_skel.so /vendor/lib/rfsa/adsp

cd $TVM_EXAMPLE/target
export TVM_EXAMPLE_ENV_SET=1
adb forward tcp:5001 tcp:5001
adb reverse tcp:9190 tcp:9190
adb shell am force-stop org.apache.tvm.tvmrpc
adb shell am start -n org.apache.tvm.tvmrpc/org.apache.tvm.tvmrpc.MainActivity

python3 bias-add_rpc.py