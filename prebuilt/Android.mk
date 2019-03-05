LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)
LOCAL_MODULE_TAGS     := optional
LOCAL_MODULE          := LeRemote
LOCAL_SRC_FILES       := LetvRemoteControl_preinstall.apk
LOCAL_CERTIFICATE     := PRESIGNED
LOCAL_MODULE_CLASS    := APPS
LOCAL_MODULE_SUFFIX   := .apk
LOCAL_DEX_PREOPT      := false
include $(BUILD_PREBUILT)
