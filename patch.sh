#!/bin/bash

# Patch the ejabberd Debian package to disable room moderators.

apt-get -y install packaging-dev
apt-get -y build-dep ejabberd

mkdir patch && cd patch
apt-get -y source ejabberd

cd ejabberd-*

dch --nmu "Remove owner affiliation from MUC room creators."

quilt push -a
quilt new ejabberd.no-muc-owner.patch
quilt add src/mod_muc_room.erl

# https://sources.debian.net/src/ejabberd/16.09-4/src/mod_muc_room.erl/#L108
sed -i "s/State = set_affiliation(Creator, owner,/State = set_affiliation(Creator, none,/" src/mod_muc_room.erl

quilt refresh
debuild -us -uc
