#!/bin/bash

export SD_CARD_PATH='/storage/82D1-0DF1'
export SD_BACKUP_IMAGE_DIR="$SD_CARD_PATH/865HDK_backup"

echo "(II) User Home Dir: $HOME"
rm -rf $HOME/865HDK_backup_images
mkdir -p $HOME/865HDK_backup_images

echo '(**) Making system partitions accessible'
adb wait-for-device root
adb disable-verity
adb reboot

echo '(**) Wait system reboot and remount partitions'
adb wait-for-device root
adb remount

echo '(**) Wait SD card mounted for 30s'
sleep 30s
adb shell 'ls /storage'
adb shell "rm -rf  $SD_BACKUP_IMAGE_DIR"
adb shell "mkdir $SD_BACKUP_IMAGE_DIR"

# https://source.android.com/docs/core/ota/dynamic_partitions/implement
export current_slot=$(adb shell bootctl get-suffix \$\(bootctl get-current-slot\))
echo "(**) Get current slot: xxxxx$current_slot"

echo "(**) (1/) Backup Android Partotions: boot$current_slot"
adb shell "dd if=/dev/block/platform/soc/1d84000.ufshc/by-name/boot$current_slot | gzip -c | split -b 500M - /storage/82D1-0DF1/865HDK_backup/boot.gz."
adb shell "ls -d /storage/82D1-0DF1/865HDK_backup/boot.gz.*" | tr '\r' ' ' | xargs -n1 adb pull
mv boot.gz.* $HOME/865HDK_backup_images
cat $HOME/865HDK_backup_images/boot.gz.* | gunzip -c > $HOME/865HDK_backup_images/boot.img

echo "(**) (2/) Backup Android Partotions: dtbo$current_slot"
adb shell "dd if=/dev/block/platform/soc/1d84000.ufshc/by-name/dtbo$current_slot | gzip -c | split -b 500M - /storage/82D1-0DF1/865HDK_backup/dtbo.gz."
adb shell "ls -d /storage/82D1-0DF1/865HDK_backup/dtbo.gz.*" | tr '\r' ' ' | xargs -n1 adb pull
mv dtbo.gz.* $HOME/865HDK_backup_images
cat $HOME/865HDK_backup_images/dtbo.gz.* | gunzip -c > $HOME/865HDK_backup_images/dtbo.img

echo "(**) (3/) Backup Android Partotions: recovery$current_slot"
adb shell "dd if=/dev/block/platform/soc/1d84000.ufshc/by-name/recovery$current_slot | gzip -c | split -b 500M - /storage/82D1-0DF1/865HDK_backup/recovery.gz."
adb shell "ls -d /storage/82D1-0DF1/865HDK_backup/recovery.gz.*" | tr '\r' ' ' | xargs -n1 adb pull
mv recovery.gz.* $HOME/865HDK_backup_images
cat $HOME/865HDK_backup_images/recovery.gz.* | gunzip -c > $HOME/865HDK_backup_images/recovery.img

echo '(**) (4/) Backup Android Partotions: metadata'
adb shell "dd if=/dev/block/platform/soc/1d84000.ufshc/by-name/metadata | gzip -c | split -b 500M - /storage/82D1-0DF1/865HDK_backup/metadata.gz."
adb shell "ls -d /storage/82D1-0DF1/865HDK_backup/metadata.gz.*" | tr '\r' ' ' | xargs -n1 adb pull
mv metadata.gz.* $HOME/865HDK_backup_images
cat $HOME/865HDK_backup_images/metadata.gz.* | gunzip -c > $HOME/865HDK_backup_images/metadata.img

echo "(**) (5/) Backup Android Partotions: vbmeta$current_slot"
adb shell "dd if=/dev/block/platform/soc/1d84000.ufshc/by-name/vbmeta$current_slot | gzip -c | split -b 500M - /storage/82D1-0DF1/865HDK_backup/vbmeta.gz."
adb shell "ls -d /storage/82D1-0DF1/865HDK_backup/vbmeta.gz.*" | tr '\r' ' ' | xargs -n1 adb pull
mv vbmeta.gz.* $HOME/865HDK_backup_images
cat $HOME/865HDK_backup_images/vbmeta.gz.* | gunzip -c > $HOME/865HDK_backup_images/vbmeta.img

echo '(**) (6/) Backup Android Partotions: super'
adb shell "dd if=/dev/block/platform/soc/1d84000.ufshc/by-name/super | gzip -c | split -b 500M - /storage/82D1-0DF1/865HDK_backup/super.gz."
adb shell "ls -d /storage/82D1-0DF1/865HDK_backup/super.gz.*" | tr '\r' ' ' | xargs -n1 adb pull
mv super.gz.* $HOME/865HDK_backup_images
cat $HOME/865HDK_backup_images/super.gz.* | gunzip -c > $HOME/865HDK_backup_images/super.img

echo '(**) (7/) Backup Android Partotions: userdata'
adb shell "dd if=/dev/block/platform/soc/1d84000.ufshc/by-name/userdata | gzip -c | split -b 500M - /storage/82D1-0DF1/865HDK_backup/userdata.gz."
adb shell "ls -d /storage/82D1-0DF1/865HDK_backup/userdata.gz.*" | tr '\r' ' ' | xargs -n1 adb pull
mv userdata.gz.* $HOME/865HDK_backup_images
cat $HOME/865HDK_backup_images/userdata.gz.* | gunzip -c > $HOME/865HDK_backup_images/userdata.img
