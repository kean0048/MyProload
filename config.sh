# #######################
# LFS Build Configuration
# ~~~~~~~~~~~~~~~~~~~~~~~

# Determine the full path of the script
FULLPATH=$(cd $(dirname $0) && pwd)

# #######################
# Version and Kernel
# ~~~~~~~~~~~~~~~~~~~~~~~

export LFS_VERSION=${LFS_VERSION:-11.2}   # LFS version
export KERNELVERS=${KERNELVERS:-6.9.4}    # Kernel version
export LFS_TGT=$(uname -m)-lfs-linux-gnu

# #######################
# Paths and Directories
# ~~~~~~~~~~~~~~~~~~~~~~~

export PACKAGE_LIST=${PACKAGE_LIST:-$FULLPATH/packages.sh}   # Package list
export PACKAGE_DIR=${PACKAGE_DIR:-$FULLPATH/packages}        # Package directory
export LOG_DIR=${LOG_DIR:-$FULLPATH/logs}                    # Log directory
export TESTLOG_DIR=${TESTLOG_DIR:-$FULLPATH/logs}            # Test log directory
export LFS=${LFS:-$FULLPATH/mnt/lfs}                         # LFS mount point
export INSTALL_MOUNT=${INSTALL_MOUNT:-$FULLPATH/mnt/install} # Install mount point

# #######################
# Image Configuration
# ~~~~~~~~~~~~~~~~~~~~~~~

export LFS_IMG=${LFS_IMG:-$FULLPATH/rinux7.img}         # Image file
export LFS_IMG_SIZE=${LFS_IMG_SIZE:-$((8*1024*1024*1024))} # Image size (10 GiB)
export LFS_FS=${LFS_FS:-ext4}                           # Filesystem type
export LFSROOTLABEL=${LFSROOTLABEL:-LFSROOT}            # Root filesystem label
export LFSEFILABEL=${LFSEFILABEL:-LFSEFI}               # EFI filesystem label
export LFSFSTYPE=${LFSFSTYPE:-ext4}                     # Filesystem type

# #######################
# Build Configuration
# ~~~~~~~~~~~~~~~~~~~~~~~

export KEEP_LOGS=true
export MAKEFLAGS=${MAKEFLAGS:--j8}              # Make flags
export RUN_TESTS=${RUN_TESTS:-false}            # Run tests flag
export ROOT_PASSWD=${ROOT_PASSWD:-password}     # Root password
export LFSHOSTNAME=${LFSHOSTNAME:-lfs}          # Hostname
export STATE_FILE=${STATE_FILE:-$FULLPATH/build-state}     # Build stage file

# #######################
# Partitioning Instructions
# ~~~~~~~~~~~~~~~~~~~~~~~

# Partitioning instructions for UEFI support
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


# Partitioning instructions for UEFI support
export FDISK_LOOP_INSTR=${FDISK_LOOP_INSTR:-"
g       # create GPT partition table
n       # new partition
1       # partition number 1
        # default - first sector
+800M   # 512 MB EFI system partition
t       # change partition type
1       # EFI System
n       # new partition
2       # partition number 2
        # default - first sector
        # default - last sector (use remaining space)
w       # write the partition table
"}
# #######################
# Validation
# ~~~~~~~~~~~~~~~~~~~~~~~

# List of required configuration keys
REQUIRED_KEYS="MAKEFLAGS PACKAGE_LIST PACKAGE_DIR LOG_DIR KEEP_LOGS LFS LFS_TGT"
REQUIRED_KEYS="$REQUIRED_KEYS LFS_FS LFS_IMG LFS_IMG_SIZE ROOT_PASSWD RUN_TESTS"
REQUIRED_KEYS="$REQUIRED_KEYS TESTLOG_DIR LFSHOSTNAME LFSROOTLABEL LFSEFILABEL"
REQUIRED_KEYS="$REQUIRED_KEYS LFSFSTYPE KERNELVERS FDISK_INSTR"

# Validate that all required configuration keys are set
for KEY in $REQUIRED_KEYS
do
    if [ -z "${!KEY}" ]
    then
        echo "ERROR: '$KEY' config is not set."
        exit -1
    fi
done

# Export required keys for usage in other scripts
for KEY in $REQUIRED_KEYS
do
    export $KEY
done

# Informative output for debugging
if [ "${VERBOSE:-false}" = true ]; then
    echo "Configuration:"
    for KEY in $REQUIRED_KEYS; do
        echo "  $KEY=${!KEY}"
    done
fi

