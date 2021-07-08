#!/bin/bash

openssl genrsa -out regner.key 2048
openssl req -new -key regner.key -out regner.csr -subj "/CN=regner/O=dev"
sudo openssl x509 -req -in regner.csr -CA /Users/xtian/.minikube/ca.crt -CAkey /Users/xtian/.minikube/ca.key -CAcreateserial -out regner.crt -days 500
openssl x509 -in  regner.crt  -noout -text

## Isolated env
kubectl config view  | grep server
docker run --rm -ti -v $PWD:/test -w /test  -v /root/.minikube/ca.crt:/ca.crt -v /usr/bin/kubectl:/usr/bin/kubectl alpine sh

## Configure kubectl for user
kubectl config set-cluster minikube --server=https://127.0.0.1:52368 --certificate-authority=/Users/xtian/.minikube/ca.crt 
kubectl config set-credentials regner --client-certificate=regner.crt --client-key=regner.key
kubectl config set-context regner --cluster=minikube --user=regner
kubectl config use-context regner

