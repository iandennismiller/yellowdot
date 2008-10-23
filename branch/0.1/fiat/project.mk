# (c) 2008 Saperea - www.saperea.com
# project.mk: project-wide configuration  

export PROJECT_NAME=SOMETHING
export PROJECT_VERSION=0.9
export MAKE_TOOL=make

.PHONY: build_project
build_project: pre_build
	@echo __________ 1.2 build_project

	cp -Rp $(MAKE_PATH)/src/ $(BUILD_PATH)/install
	chmod -R u+w $(BUILD_PATH)/install
	-cp -Rp $(MAKE_PATH)/fiat/$(FIAT_CONFIG)/settings/ $(BUILD_PATH)/install
	cd $(BUILD_PATH); for dir in `find . -name '.svn'` ; do rm -rf $$dir; done

.PHONY: pre_install_project
pre_install_project:
	@echo __________ 2.1 pre_install_project

.PHONY: post_install_project
post_install_project: perform_install
	@echo __________ 2.4 post_install_project
	
#	chmod 755 /usr/bin/fiat.pl
	
#	chmod 600 /etc/fiat/svn_passwd

.PHONY: test
test: install
	@echo __________ test

.PHONY: uninstall
uninstall:
	@echo __________ uninstall
	
# $Id:project.mk 114 2008-03-11 19:24:49Z idm $
