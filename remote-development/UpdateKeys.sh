#!/bin/sh
# Update the keys stored in ssh.yaml from the authorized-keys file
kubectl --namespace development delete secret ssh-keys
kubectl --namespace development create secret generic ssh-keys --from-file=./authorized_keys
