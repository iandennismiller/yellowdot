

"""
# create .html documentation

    pod2html --css "http://iandennismiller.com/css/perl_pod.css" --outfile $(MAKE_PATH)/tmp/index.html \
        --infile $(MAKE_PATH)/bin/yellowdot; rm $(MAKE_PATH)/pod2htmd.tmp $(MAKE_PATH)/pod2htmi.tmp

# copy index.html

    scp -o port=$(SSH_PORT) $(MAKE_PATH)/tmp/index.html $(SSH_LOGIN)@$(SSH_HOST):$(REMOTE_PATH)/software/yellowdot

# copy yellowdot

    scp -o port=$(SSH_PORT) $(MAKE_PATH)/bin/yellowdot $(SSH_LOGIN)@$(SSH_HOST):$(REMOTE_PATH)/software/yellowdot

"""