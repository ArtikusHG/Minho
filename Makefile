ARCHS = armv7 armv7s arm64
include /var/theos/makefiles/common.mk

TWEAK_NAME = Minho
Minho_FILES = Tweak.xm
Minho_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
