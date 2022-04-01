#!/bin/bash

# 
sudo su - enterprisedb -c "
cat >>~/.bash_profile <<EOF
alias sergio='psql -h localhost -U sergio edb'
export PS1='\033[31;1m\]┌──\[\033[32;1m\]\u\[\033[m\]\[\033[31;1m\]@\[\033[34;1m\]\h:\[\033[33;1m\]\w\[\033[m\]\033[31;1m\]\n└─>\033[m\] '
EOF
"

cat >>~/.bash_profile <<EOF
alias ep='sudo su - enterprisedb'
export PS1='\033[31;1m\]┌──\[\033[32;1m\]\u\[\033[m\]\[\033[31;1m\]@\[\033[34;1m\]\h:\[\033[33;1m\]\w\[\033[m\]\033[31;1m\]\n└─>\033[m\] '
EOF

# Migration toolkit installation
sudo dnf -y install edb-migrationtoolkit java
sudo cp /vagrant_software/ojdbc8.jar /usr/edb/migrationtoolkit/lib
sudo cat > /usr/edb/migrationtoolkit/etc/toolkit.properties <<EOF
SRC_DB_URL=jdbc:oracle:thin:@192.168.56.202:1521/pdb1
SRC_DB_USER=system
SRC_DB_PASSWORD=manager

TARGET_DB_URL=jdbc:edb://localhost:5444/edb
TARGET_DB_USER=sergio
TARGET_DB_PASSWORD=sergio
EOF
