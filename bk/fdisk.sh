#!/bin/bash

export FDISK_INSTR=${FDISK_INSTR:-"
g       # create GPT partition table
n       # new partition
1       # partition number 1
        # default - first sector
+800M   # 512 MB EFI system partition
t       # change partition type
1       # EFI System
n
2

+10G
t
2
19
n       # new partition
3       # partition number 2
        # default - first sector
        # default - last sector (use remaining space)
w       # write the partition table
"}

FDISK_INSTR=$(echo "$FDISK_INSTR" | sed 's/ *#.*//')
# 设备名称
DEVICE=$1
set -x
# 使用 fdisk 创建分区表和分区
echo -e"${FDISK_INSTR}" | fdisk ${DEVICE}
set +x
# 更新分区表
partprobe ${DEVICE}

# 格式化分区
mkfs.vfat -F 32 ${DEVICE}1    # 格式化为 FAT32
mkswap ${DEVICE}2             # 格式化为 swap
mkfs.ext4 ${DEVICE}3          # 格式化为 ext4

# 启用交换分区
swapon ${DEVICE}2

# 打印分区信息
fdisk -l ${DEVICE}

