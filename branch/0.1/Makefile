# (c) 2008 Saperea - www.saperea.com
# Makefile: global configuration of software deployment  

export FIAT_VERSION=0.9
export MAKE_PATH=$(CURDIR)
export BUILD_PATH=$(MAKE_PATH)/tmp/build
COPY_CMD=cp -Rp

.PHONY: all
all: build

include $(MAKE_PATH)/fiat/project.mk

# if the FIAT_CONFIG flag is not set, then choose the first config we find
ifeq ($(FIAT_CONFIG),)
export FIAT_CONFIG = $(shell ls $(MAKE_PATH)/fiat |grep -v \.mk |grep -v \.d | head -n 1)
endif

include $(MAKE_PATH)/fiat/$(FIAT_CONFIG)/custom.mk
-include $(MAKE_PATH)/fiat/developer.mk

# compatibility with debianization tools
ifneq ($(DESTDIR),)
export INSTALL_PATH=$(DESTDIR)
endif

# if no explicit path has been set yet, default to root path
ifeq ($(INSTALL_PATH),)
export INSTALL_PATH=/
endif

$(warning 		0.1 FIAT_CONFIG = '$(FIAT_CONFIG)')
$(warning 		0.2 MAKE_PATH = '$(MAKE_PATH)')
$(warning 		0.3 DESTDIR = '$(DESTDIR)')
$(warning 		0.4 INSTALL_PATH = '$(INSTALL_PATH)')

.PHONY: clean
clean:
	@echo __________ clean
	-rm -rf $(MAKE_PATH)/tmp

.PHONY: build
build: build_project
	@echo __________ 1.0 build: DONE

.PHONY: pre_build
pre_build: 
	@echo __________ 1.1 pre_build

	-rm -rf $(BUILD_PATH)/install
	-rm -rf $(BUILD_PATH)/fiat

	-mkdir -p$(VERBOSE) $(BUILD_PATH)/install \
		$(BUILD_PATH)/fiat/$(FIAT_CONFIG)

	cp -p$(VERBOSE) $(MAKE_PATH)/Makefile $(BUILD_PATH)
	cp -p$(VERBOSE) $(MAKE_PATH)/fiat/project.mk $(BUILD_PATH)/fiat
	cp -p$(VERBOSE) $(MAKE_PATH)/fiat/$(FIAT_CONFIG)/custom.mk $(BUILD_PATH)/fiat/$(FIAT_CONFIG)
	cp -Rp$(VERBOSE) $(MAKE_PATH)/fiat/$(FIAT_CONFIG)/settings $(BUILD_PATH)/fiat/$(FIAT_CONFIG)

.PHONY: install
install: post_install_custom
	@echo __________ 2.0 install: DONE

.PHONY: perform_install
perform_install: pre_install_custom
	@echo __________ 2.3 perform_install
ifeq (1,$(shell if [ -e $(BUILD_PATH) ]; then echo 1; fi))
	$(COPY_CMD) $(BUILD_PATH)/install/* $(INSTALL_PATH)/
else
	$(COPY_CMD) $(MAKE_PATH)/install/* $(INSTALL_PATH)/
endif
	
# $Id: Makefile 186 2008-08-20 01:13:09Z idm $
	