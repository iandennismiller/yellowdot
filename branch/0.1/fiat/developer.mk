# (c) 2008 Saperea - www.saperea.com
# developer.mk: workflow for developers, including deployment to remote hosts  
# make deploy [deploy_install] FIAT_CONFIG=svn

include $(MAKE_PATH)/fiat/$(FIAT_CONFIG)/deploy.mk
SSH_FLAGS = -o port=$(SSH_PORT) -o user=$(SSH_LOGIN)
FIAT_DEV_VERSION=0.9
DIST_NAME=$(PROJECT_NAME)-$(PROJECT_VERSION)

# convert a dist_name into a deb_name by swapping '_' with '-'
DEB_NAME=$(shell echo $(DIST_NAME) | sed -e 's/_/%!%!/' | sed -e 's/-/_/' | sed -e 's/%!%!/-/')

###
# create an installable binary

.PHONY: dist
dist: build
	@echo __________ 3.0 dist
	-rm -rf $(MAKE_PATH)/tmp/$(DIST_NAME)

	cp -Rp $(BUILD_PATH)/ $(MAKE_PATH)/tmp/$(DIST_NAME)
	cp -Rp $(MAKE_PATH)/doc $(MAKE_PATH)/tmp/$(DIST_NAME)
	cd $(MAKE_PATH)/tmp/$(DIST_NAME); for dir in `find . -name '.svn'` ; do rm -rf $$dir; done

	-mkdir -p $(MAKE_PATH)/tmp/dist

.PHONY: changelog
changelog:
	@echo __________ changelog

###
# render man pages

.PHONY: docs
docs: build
	@echo __________ 3.2 docs
	mkdir -p $(MAKE_PATH)/tmp/doc
	
	find $(BUILD_PATH)/install -name '*.pl' | xargs -I % cp % $(MAKE_PATH)/tmp/doc 
	find $(MAKE_PATH)/tmp/doc -name '*.pl' | xargs -I % pod2man % %.1
	find $(MAKE_PATH)/tmp/doc -name '*.1' | xargs gzip -f

	-mkdir -p $(MAKE_PATH)/tmp/$(DIST_NAME)/install/usr/share/man/man1
	-cp $(MAKE_PATH)/tmp/doc/*.gz $(MAKE_PATH)/tmp/$(DIST_NAME)/install/usr/share/man/man1

###
# deb utilities
# to build in absence of fakeroot, use sudo

.PHONY: deb
deb: binary_tar
	@echo __________ 6.0 deb
	-rm -rf $(MAKE_PATH)/tmp/deb

	cp -Rp $(MAKE_PATH)/tmp/$(DIST_NAME)/install/ $(MAKE_PATH)/tmp/deb  
	cp -Rp $(MAKE_PATH)/fiat/debian.d $(MAKE_PATH)/tmp/deb/DEBIAN

	cd $(MAKE_PATH)/tmp/deb/DEBIAN; for dir in `find . -name '.svn'` ; do rm -rf $$dir; done
	
	sudo chown -R root:wheel $(MAKE_PATH)/tmp/deb
	cd $(MAKE_PATH)/tmp; dpkg-deb --build deb
	mv $(MAKE_PATH)/tmp/deb.deb $(MAKE_PATH)/tmp/dist/$(DEB_NAME)-1_all.deb
	sudo rm -rf $(MAKE_PATH)/tmp/deb
	
###
# tar utilities

.PHONY: binary_tar
binary_tar: dist
	@echo __________ 5.0 binary_tar
	cd $(MAKE_PATH)/tmp; tar czf$(VERBOSE) $(MAKE_PATH)/tmp/dist/$(DIST_NAME).tgz $(DIST_NAME)/

.PHONY: source_tar
source_tar:
	@echo __________ source_tar

	-rm -rf $(MAKE_PATH)/tmp/src
	-mkdir -pv $(MAKE_PATH)/tmp/dist \
		$(MAKE_PATH)/tmp/src/$(DIST_NAME)

	for file in `ls -1A |grep -v tmp |grep -v .svn` ; \
		do cp -r $$file $(MAKE_PATH)/tmp/src/$(DIST_NAME); done
	
	cd $(MAKE_PATH)/tmp/src/$(DIST_NAME); for dir in `find . -name '.svn'` ; do rm -rf $$dir; done
	
	cd $(MAKE_PATH)/tmp/src; tar czf$(VERBOSE) $(MAKE_PATH)/tmp/dist/$(DIST_NAME)-src.tgz $(DIST_NAME)/

###
# deployment to other machines

.PHONY: deploy_clean
deploy_clean:
	@echo __________ deploy_clean
	ssh $(SSH_FLAGS) $(SSH_HOST) "bash -l -c '$(MAKE_TOOL) -C $(REMOTE_PATH)/$(DIST_NAME) FIAT_CONFIG=$(FIAT_CONFIG) clean'"

.PHONY: deploy
deploy: dist
	@echo __________ 4.0 deploy
	rsync -az -e "ssh -o port=$(SSH_PORT)" $(MAKE_PATH)/tmp/$(DIST_NAME) $(SSH_LOGIN)@$(SSH_HOST):$(REMOTE_PATH) 

.PHONY: deploy_build
deploy_build: deploy_source_tar
	@echo __________ deploy_build
	ssh $(SSH_FLAGS) $(SSH_HOST) "bash -l -c '$(MAKE_TOOL) -C $(REMOTE_PATH)/$(DIST_NAME) FIAT_CONFIG=$(FIAT_CONFIG) build'"

.PHONY: deploy_install
deploy_install: 
	@echo __________ deploy_install
	ssh $(SSH_FLAGS) $(SSH_HOST) "bash -l -c '$(MAKE_TOOL) -C $(REMOTE_PATH)/$(DIST_NAME) FIAT_CONFIG=$(FIAT_CONFIG) install'"

.PHONY: deploy_test
deploy_test:
	@echo __________ deploy_test
	ssh $(SSH_FLAGS) $(SSH_HOST) "bash -l -c '$(MAKE_TOOL) -C $(REMOTE_PATH)/$(DIST_NAME) FIAT_CONFIG=$(FIAT_CONFIG) test'"

.PHONY: deploy_sanitize
deploy_sanitize:
	@echo __________ deploy_sanitize
	-ssh $(SSH_FLAGS) $(SSH_HOST) "rm $(REMOTE_PATH)/$(DIST_NAME).tgz; rm $(REMOTE_PATH)/$(DIST_NAME)-src.tgz; rm -rf $(REMOTE_PATH)/$(DIST_NAME)"

# $Id$	