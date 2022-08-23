#!/bin/bash

export ADSP_LIBS="/system/lib/rfsa/adsp;/system/vendor/lib/rfsa/adsp;/vendor/dsp;/system/vendor/lib64;/vendor/lib/rfsa/adsp;/vendor/lib/rfsa/adsp/tests"
export LD_LIBRS="\${LD_LIBRARY_PATH}:/system/lib/rfsa/adsp:/system/vendor/lib/rfsa/adsp:/vendor/dsp:/system/vendor/lib64:/vendor/lib/rfsa/adsp:/vendor/lib/rfsa/adsp/tests"

adb shell "export ADSP_LIBRARY_PATH=\"${ADSP_LIBS}\" && LD_LIBRARY_PATH=\"${LD_LIBRS}\" \\
    /data/sysMonApp profiler --debugLevel 0 --samplingPeriod 10 --q6 cdsp --profileFastrpcTimeline 1"

adb shell "export ADSP_LIBRARY_PATH=\"${ADSP_LIBS}\" && LD_LIBRARY_PATH=\"${LD_LIBRS}\" \\
    /data/sysMonApp benchmark -f conv3x3"