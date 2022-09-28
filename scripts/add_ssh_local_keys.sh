#!/bin/bash
ssh-keyscan -H 192.168.192.10 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.192.11 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.192.12 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.192.13 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.192.14 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.192.21 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.192.22 >> ~/.ssh/known_hosts
ssh-keyscan -H 192.168.192.23 >> ~/.ssh/known_hosts
