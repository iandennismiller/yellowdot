# (c) 2008 Saperea - www.saperea.com
# custom.mk: configuration that is specific to this deployment, once it has been deployed

export INSTALL_PATH=/
#export VERBOSE=v
#export MAKE_TOOL=gmake

.PHONY: pre_install_custom
pre_install_custom: pre_install_project
	@echo __________ 2.2 pre_install_custom

.PHONY: post_install_custom
post_install_custom: post_install_project
	@echo __________ 2.5 post_install_custom

# $Id:custom.mk 89 2008-01-23 12:16:35Z idm $
