import os

def docs():
    css_url = "http://iandennismiller.com/css/perl_pod.css"
    cmd = 'pod2html --css "%s" --outfile index.html --infile bin/yellowdot.pl; rm pod2*' % css_url
    os.system(cmd)

    #pod2html --css "http://iandennismiller.com/css/perl_pod.css" --outfile $(MAKE_PATH)/tmp/index.html \
    #    --infile $(MAKE_PATH)/bin/yellowdot; rm $(MAKE_PATH)/pod2htmd.tmp $(MAKE_PATH)/pod2htmi.tmp


"""
# create .html documentation


# copy index.html

    scp -o port=$(SSH_PORT) $(MAKE_PATH)/tmp/index.html $(SSH_LOGIN)@$(SSH_HOST):$(REMOTE_PATH)/software/yellowdot

# copy yellowdot

    scp -o port=$(SSH_PORT) $(MAKE_PATH)/bin/yellowdot $(SSH_LOGIN)@$(SSH_HOST):$(REMOTE_PATH)/software/yellowdot

"""