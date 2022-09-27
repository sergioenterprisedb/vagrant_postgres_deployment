#!/bin/bash
cat /vagrant_keys/public_key.txt >> ./.ssh/authorized_keys
test -f /home/vagrant/.ssh/config && rm /home/vagrant/.ssh/config
touch /home/vagrant/.ssh/config
