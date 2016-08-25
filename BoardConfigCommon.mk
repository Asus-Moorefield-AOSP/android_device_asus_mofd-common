#
# Copyright 2013 The Android Open-Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

COMMON_PATH=device/asus/mofd-common

## Architecture
TARGET_ARCH := x86
TARGET_ARCH_VARIANT := silvermont
TARGET_CPU_ABI := x86
TARGET_CPU_ABI2 := armeabi-v7a
TARGET_CPU_ABI_LIST := x86,armeabi-v7a,armeabi
TARGET_CPU_ABI_LIST_32_BIT := x86,armeabi-v7a,armeabi

TARGET_SPECIFIC_HEADER_PATH := device/asus/mofd-common/include

TARGET_DROIDBOOT_LIBS := libintel_droidboot

TARGET_BOARD_PLATFORM := moorefield

# Adb
#BOARD_FUNCTIONFS_HAS_SS_COUNT := true

# Audio
BOARD_USES_ALSA_AUDIO := true
BOARD_USES_TINY_ALSA_AUDIO := true
TARGET_TINY_ALSA_IGNORE_SILENCE_SIZE := true

# Binder API version
TARGET_USES_64_BIT_BINDER := true

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := device/asus/mofd-common/bluetooth
BOARD_CUSTOM_BT_CONFIG := device/asus/mofd-common/bluetooth/vnd_fugu.txt

# bootstub as 2nd bootloader
TARGET_BOOTLOADER_IS_2ND := true

# Camera
INTEL_USE_CAMERA_UVC := true
INTEL_VIDEO_XPROC_SHARING := true
BOARD_GLOBAL_CFLAGS += -DCAMERA_VENDOR_L_COMPAT
TARGET_PROVIDES_CAMERA_HAL := true
TARGET_HAS_LEGACY_CAMERA_HAL1 := true


# Charger
WITH_CM_CHARGER := false
BOARD_CHARGER_ENABLE_SUSPEND := true

# Dex-preoptimization: Speeds up initial boot (if we ever o a user build, which we don't)
ifeq ($(HOST_OS),linux)
  ifeq ($(TARGET_BUILD_VARIANT),user)
    ifeq ($(WITH_DEXPREOPT),)
      WITH_DEXPREOPT := true
    endif
  endif
endif

# Hardware
#BOARD_HARDWARE_CLASS := device/asus/mofd-common/cmhw

## HIDL
DEVICE_MANIFEST_FILE := device/asus/mofd-common/manifest.xml
DEVICE_MATRIX_FILE := device/asus/mofd-common/compatibility_matrix.xml

# Healthd
#BOARD_HAL_STATIC_LIBRARIES := libhealthd.moorefield

# Houdini: enable ARM codegen for x86
BUILD_ARM_FOR_X86 := true

## Graphics
BOARD_EGL_CFG := device/asus/mofd-common/gpu/egl.cfg
BOARD_GFX_REV := RGX6400
BOARD_USES_LIBDRM := true
ENABLE_IMG_GRAPHICS := true
BOARD_USES_PRE_ION_X86 := true
ENABLE_MRFL_GRAPHICS := true
HWUI_IMG_FBO_CACHE_OPTIM := true
# DPST
INTEL_DPST := true
INTEL_HWC_MOOREFIELD := true
INTEL_VA := true
MAX_EGL_CACHE_ENTRY_SIZE := 65536
MAX_EGL_CACHE_SIZE := 1048576
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 3
OVERRIDE_RS_DRIVER := libPVRRS.so
SF_START_GRAPHICS_ALLOCATOR_SERVICE := true
SF_VSYNC_EVENT_PHASE_OFFSET_NS := 5000000
TARGET_SUPPORT_HDMI_PRIMARY := true
TARGET_USES_HWC2 := true
# Enabled to carry out all drawing operations performed
# on a View's canvas with GPU for 2D rendering pipeline
USE_OPENGL_RENDERER := true
# System's VSYNC phase offsets in nanoseconds
VSYNC_EVENT_PHASE_OFFSET_NS := 7500000

# Init
TARGET_INIT_VENDOR_LIB := libinit_mofd
TARGET_LIBINIT_DEFINES_FILE := device/asus/mofd-common/init/init_mofd.cpp
TARGET_INIT_UMOUNT_AND_FSCK_IS_UNSAFE := true
TARGET_IGNORE_RO_BOOT_SERIALNO := true

# Inline kernel building
TARGET_KERNEL_SOURCE := kernel/asus/moorefield
TARGET_KERNEL_ARCH := x86_64
BOARD_KERNEL_IMAGE_NAME := bzImage
TARGET_KERNEL_CONFIG := zenfone2_defconfig
TARGET_KERNEL_CROSS_COMPILE_PREFIX := x86_64-linux-android-
LZMA_RAMDISK_TARGETS := recovery

# Kernel cmdline
BOARD_KERNEL_CMDLINE := init=/init pci=noearly androidboot.selinux=permissive console=logk0 loglevel=7 vmalloc=256M androidboot.hardware=mofd_v1 watchdog.watchdog_thresh=60 androidboot.spid=xxxx:xxxx:xxxx:xxxx:xxxx:xxxx androidboot.serialno=01234567890123456789 gpt snd_pcm.maximum_substreams=8 ptrace.ptrace_can_access=1 panic=15 ip=50.0.0.2:50.0.0.1::255.255.255.0::usb0:on debug_locks=0 n_gsm.mux_base_conf=\"ttyACM0,0 ttyXMM0,1\" bootboost=1'
#BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

# Lights
TARGET_PROVIDES_LIBLIGHT := true

# Media
TARGET_NUPLAYER_CANNOT_SET_SURFACE_WITHOUT_A_FLUSH := true
BOARD_USES_WRS_OMXIL_CORE := true
BOARD_USES_MRST_OMX := true
USE_HW_VP8 := true

# Media: DRM Protected Video
BOARD_WIDEVINE_OEMCRYPTO_LEVEL := 1
USE_INTEL_SECURE_AVC := true

# Settings for the Media SDK library and plug-ins:
# - USE_MEDIASDK: use Media SDK support or not
# - MFX_IPP: sets IPP library optimization to use
USE_MEDIASDK := true
MFX_IPP := p8

# Mkbootimg
BOARD_CUSTOM_BOOTIMG_MK := device/asus/mofd-common/mkbootimg.mk

# Video Post Processing
TARGET_HAS_ISV := true


BOARD_GLOBAL_CFLAGS += -DGFX_BUF_EXT

# Partitions
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2415919104
BOARD_FLASH_BLOCK_SIZE := 2048
BOARD_BOOTIMAGE_PARTITION_SIZE := 16777216
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 1677721600
BOARD_VENDORIMAGE_PARTITION_SIZE := 268435456
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
#BOARD_USERIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

# PowerHAL
TARGET_POWERHAL_VARIANT := mofd_v1

## Properties
TARGET_SYSTEM_PROP += device/asus/mofd-common/system.prop

# Radio
#BOARD_PROVIDES_LIBRIL := true

# Recovery
#RECOVERY_VARIANT := twrp
TARGET_RECOVERY_PIXEL_FORMAT := "BGRA_8888"
BOARD_GLOBAL_CFLAGS += -DNO_SECURE_DISCARD
TARGET_RECOVERY_DEVICE_MODULES := libinit_mofd librecovery_updater_mofd thermald
BOARD_HAS_LARGE_FILESYSTEM := true

ifeq ($(RECOVERY_VARIANT),twrp)
TARGET_RECOVERY_FSTAB := device/asus/mofd-common/recovery/twrp.fstab
BOARD_HAS_NO_REAL_SDCARD := true
TW_THEME := portrait_hdpi
RECOVERY_SDCARD_ON_DATA := true
TW_DEFAULT_BRIGHTNESS := "160"
TW_INCLUDE_CRYPTO := true
TW_INCLUDE_NTFS_3G := true
TW_EXCLUDE_SUPERSU := true
else
TARGET_RECOVERY_FSTAB := device/asus/mofd-common/rootdir/etc/fstab.mofd_v1
endif

# Release tools
TARGET_RELEASETOOLS_EXTENSIONS := device/asus/mofd-common/releasetools

# Security
BUILD_WITH_SECURITY_FRAMEWORK := chaabi_token
BUILD_WITH_CHAABI_SUPPORT := true

# SELinux
#BOARD_SEPOLICY_DIRS += device/asus/mofd-common/sepolicy

# Tap-to-Wake
TARGET_TAP_TO_WAKE_NODE := "/sys/devices/pci0000:00/0000:00:09.2/i2c-7/7-0038/ftsdclickmode"

## Wi-Fi
BOARD_HOSTAPD_PRIVATE_LIB  := lib_driver_cmd_bcmdhd
BOARD_WLAN_DEVICE := bcmdhd
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
WIFI_DRIVER_FW_PATH_PARAM := "/sys/module/bcmdhd/parameters/firmware_path"
WIFI_DRIVER_FW_PATH_AP := "/vendor/firmware/fw_bcmdhd_apsta.bin"
WIFI_DRIVER_FW_PATH_STA := "/vendor/firmware/fw_bcmdhd.bin"
WPA_SUPPLICANT_VERSION := VER_0_8_X

# Use the non-open-source parts, if they're present
-include vendor/asus/mofd-common/BoardConfigVendor.mk
