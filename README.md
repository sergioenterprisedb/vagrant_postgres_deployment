# EDB Reference Architectures in Vagrant
## Prerequisites
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/downloads)
- Python 3
- pip3
- [edb-deployment](https://github.com/EnterpriseDB/postgres-deployment)

## How to create vagrant VM's in VirtualBox
There are 3 reference architectures available:
- EDB-RA-1: 1 Primary, 1 barman, 1 pem
- EDB-RA-2: 1 Primary, 2 standby's, 1 barman, 1 pem
- EDB-RA-3: 1 Primary, 2 standby's, 1 barman, 1 pem, 3 PgBouncers

[EDB Reference Architectures](https://github.com/EnterpriseDB/edb-ref-archs/blob/main/edb-reference-architecture-codes/README.md)

To deploy VM's in VirtualBox using vagrant execute this command:
```
./vagrant_up.sh -a [reference architecture]

Ex:
./vagrant_up.sh -a EDB-RA-2
```
To show VM's:
```
vagrant status

Current machine states:

pg1                       running (virtualbox)
pem1                      running (virtualbox)
pg2                       running (virtualbox)
pg3                       running (virtualbox)
backup1                   running (virtualbox)
pooler1                   not created (virtualbox)
pooler2                   not created (virtualbox)
pooler3                   not created (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```
# How to deploy Postgres or EPAS
To deploy reference architectures use this command:
```
./deploy.sh -a [reference architecture] -t [PostgreSQL type] -v [version] -p [project name]
Ex:
./deploy.sh -a EDB-RA-2 -t EPAS -v 14 -p test
...
Creating project directory /Users/ToontjeM/.edb-deployment/baremetal/test ... ok
Loading Cloud specifications ... ok
Copying SSH key pair into /Users/ToontjeM/.edb-deployment/baremetal/test ... ok
Building Ansible vars file /Users/ToontjeM/.edb-deployment/baremetal/test/ansible_vars.json ... ok
Copying Ansible playbook file into /Users/ToontjeM/.edb-deployment/baremetal/test/playbook.yml ... ok
Build Ansible inventory file /Users/ToontjeM/.edb-deployment/baremetal/test/inventory.yml ... ok
Installing Ansible collection edb_devops.edb_postgres:>=3.10.0,<4.0.0 ... ok
Deploying components with Ansible ... ok
Extracting data from the inventory file ... ok

PEM Server: https://192.168.56.10:8443/pem
PEM User: pemadmin
PEM Password: UYtqfrSZSvSNyyqyXsSe

    Name       Public IP      SSH User      Private IP
=========================================================
    backup1    192.168.56.14     vagrant    192.168.56.14
       pem1    192.168.56.10     vagrant    192.168.56.10
        pg1    192.168.56.11     vagrant    192.168.56.11
        pg2    192.168.56.12     vagrant    192.168.56.12
        pg3    192.168.56.13     vagrant    192.168.56.13

```

# How to connect
## Connect to vagrant
```
vagrant ssh <vm_name>
Ex:

vagrant ssh pg1
or
vagrant ssh pg2
or
vagrant ssh pg3
```

## Connect with ssh
```
# Connect to PEM
ssh -i .vagrant/machines/primary/virtualbox/private_key vagrant@192.168.56.10

# Connect to primary
ssh -i .vagrant/machines/primary/virtualbox/private_key vagrant@192.168.56.11

# Connect to Standby 1
ssh -i .vagrant/machines/primary/virtualbox/private_key vagrant@192.168.56.12

# Connect to Standby 2
ssh -i .vagrant/machines/primary/virtualbox/private_key vagrant@192.168.56.13
```
# Connect to PEM
Connect to this URL: https://192.168.56.10:8443/pem

# Other useful commands
## Postgres logs
```
cd /var/log/postgres/
or
cd /var/log/edb/
```

## Obtain Passwords
```
ll ~/.edb-deployment/baremetal/test/.edbpass
edb-deployment baremetal passwords test
```
## Check replication
```
-- Primary
select * from pg_replication_slots;
-- Standbys
select * from pg_stat_replication;
```

## Change postgres password
```
psql <<EOF
alter user postgres password 'postgres';
EOF
```

## EFM Commands

```
sudo su - efm
cd /usr/edb/efm-4.2/bin/
# Show cluster
./efm cluster-status main
# Switch over
./efm promote main -switchover
```

## $PGDATA directory
```
cd /var/lib/edb/as14/main/data/

- Add line 
host    all     all     127.0.0.1/32 trust
```
