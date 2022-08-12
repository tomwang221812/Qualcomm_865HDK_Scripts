#!/bin/bash

export SNPE_DIR='/home/north/snpe-1.64.0.3605'
export QNN_DIR='/home/north/qnn-v1.16.0.220808064918_38359'

# Define binary architeture, OS and hexagon architeture
export TARGET_ARCH='aarch64'
export TARGET_OS='android'
export TARGET_COMPILER='clang8.0'
export TARGET_HEXAGON_ARCH='v66'

# Define where to install
export TARGET_SNPE_DIR="/data/${SNPE_DIR##*/}"
export TARGET_QNN_DIR="/data/${QNN_DIR##*/}"

# Define Target BIN
export TARGET_SNPE_BIN="${TARGET_SNPE_DIR}/bin/${TARGET_ARCH}-${TARGET_OS}-${TARGET_COMPILER}"
export TARGET_QNN_BIN="${TARGET_QNN_DIR}/target/${TARGET_ARCH}-${TARGET_OS}/bin"
# Define Target LIB
export TARGET_SNPE_LIBS="${TARGET_SNPE_DIR}/lib/${TARGET_ARCH}-${TARGET_OS}-${TARGET_COMPILER}"
export TARGET_SNPE_DSP_LIBS="${TARGET_SNPE_DIR}/dsp"
export TARGET_QNN_LIBS="${TARGET_QNN_DIR}/target/${TARGET_ARCH}-${TARGET_OS}/lib"
export TARGET_QNN_HEXAGON_LIBS="${TARGET_QNN_DIR}/target/hexagon-${TARGET_HEXAGON_ARCH}/lib"

# Run adb as root and enable read write
adb wait-for-device
adb root
adb disable-verity
adb reboot

adb wait-for-device
adb root
adb remount

# Create Dir for both SNPE and QNN with version number
adb shell mkdir $TARGET_SNPE_DIR
adb shell mkdir $TARGET_QNN_DIR

# Push files to targer DIRs
adb push $SNPE_DIR/* $TARGET_SNPE_DIR
adb push $QNN_DIR/* $TARGET_QNN_DIR

# Give executable file access privillage
adb shell chmod -R +x $TARGET_SNPE_BIN
adb shell chmod -R +x $TARGET_QNN_BIN

# Test Componets
# Test SNPE with Platform validator
adb shell "ADSP_LIBRARY_PATH=${TARGET_SNPE_LIBS}:${TARGET_SNPE_DSP_LIBS} LD_LIBRARY_PATH=${TARGET_SNPE_LIBS}:${TARGET_SNPE_DSP_LIBS} ./${TARGET_SNPE_BIN}/snpe-platform-validator --runtime all"
