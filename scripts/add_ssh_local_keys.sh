#!/bin/bash
ssh-keyscan -H 192.168.56.10 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.56.11 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.56.12 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.56.13 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.56.14 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.56.21 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.56.22 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.56.23 >> ~/.ssh/known_hosts
