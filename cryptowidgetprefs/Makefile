TARGET := iphone:clang:latest:7.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CryptoWidgetPrefs

CryptoWidgetPrefs_FILES = CRPRootListController.m
CryptoWidgetPrefs_FRAMEWORKS = UIKit
CryptoWidgetPrefs_PRIVATE_FRAMEWORKS = Preferences
CryptoWidgetPrefs_INSTALL_PATH = /Library/PreferenceBundles
CryptoWidgetPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
