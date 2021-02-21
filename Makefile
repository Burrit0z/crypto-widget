export ARCHS = arm64 arm64e
export TARGET := iphone:clang:latest:13.0
export SYSROOT = $(THEOS)/sdks/iPhoneOS.sdk
export FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CRPCryptoWidget

CRPCryptoWidget_FILES = Widget/CRPCryptoWidget.m
CRPCryptoWidget_FRAMEWORKS = UIKit
CRPCryptoWidget_INSTALL_PATH = /Library/Multipla/Widgets
CRPCryptoWidget_CFLAGS = -fobjc-arc

ADDITIONAL_CFLAGS += -DTHEOS_LEAN_AND_MEAN

include $(THEOS_MAKE_PATH)/bundle.mk
SUBPROJECTS += Prefs
include $(THEOS_MAKE_PATH)/aggregate.mk
