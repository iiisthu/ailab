#!/bin/bash

while IFS=, read USER EMAIL UIDD GIDD
do
  if [ -n "$(echo "$USER" | tr -d '\r')" ]; then
    echo "username : $USER"	

    if [ ! -d "./yamls/values_$(echo "$USER" | tr -d '\r').yaml" ];then
      echo "delete delete pods pvcs namespace in k8s"
      helm delete admin-$(echo "$USER" | tr -d '\r') --namespace=admin-helm
      helm delete gfshome-$(echo "$USER" | tr -d '\r') --namespace=admin-helm
      helm delete ssdshare-$(echo "$USER" | tr -d '\r') --namespace=admin-helm
      helm delete testuser-$(echo "$USER" | tr -d '\r')  --namespace=$(echo "$USER" | tr -d '\r')
      kubectl delete namespace $(echo "$USER" | tr -d '\r')
    else
      echo "there is no yaml file for $USER"
    fi
  fi
done < $1
