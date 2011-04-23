# (c) 2008 Saperea - www.saperea.com
# custom.mk: configuration that is specific to this deployment, once it has been deployed

export INSTALL_PATH=/home/iandenn
#export VERBOSE=v

.PHONY: pre_install_custom
pre_install_custom: pre_install_project
	@echo __________ 2.2 pre_install_custom

.PHONY: post_install_custom
post_install_custom: post_install_project
	@echo __________ 2.5 post_install_custom

.PHONY: release
release:
	@echo __________ release

# create .html documentation

	pod2html --css "http://iandennismiller.com/css/perl_pod.css" --outfile $(MAKE_PATH)/tmp/index.html \
		--infile $(MAKE_PATH)/bin/yellowdot; rm $(MAKE_PATH)/pod2htmd.tmp $(MAKE_PATH)/pod2htmi.tmp

# copy index.html

	scp -o port=$(SSH_PORT) $(MAKE_PATH)/tmp/index.html $(SSH_LOGIN)@$(SSH_HOST):$(REMOTE_PATH)/software/yellowdot

# copy yellowdot

	scp -o port=$(SSH_PORT) $(MAKE_PATH)/bin/yellowdot $(SSH_LOGIN)@$(SSH_HOST):$(REMOTE_PATH)/software/yellowdot

# $Id:custom.mk 89 2008-01-23 12:16:35Z idm $
