#!/bin/bash

parallel-ssh -H n02 mkdir -p /gfs-sata/to_be_delete

while IFS=, read USER EMAIL UIDD GIDD
do
  if [ -n "$(echo "$USER" | tr -d '\r')" ]; then
    echo "username : $USER"	

    if [ ! -d "./yamls/values_$(echo "$USER" | tr -d '\r').yaml" ];then
      echo "delete delete pods pvcs namespace in k8s"
      helm delete admin-$(echo "$USER" | tr -d '\r') --namespace=$(echo "$USER" | tr -d '\r')
      helm delete user-$(echo "$USER" | tr -d '\r')  --namespace=$(echo "$USER" | tr -d '\r')
      kubectl delete namespace $(echo "$USER" | tr -d '\r')
    else
      echo "there is no yaml file for $USER"
    fi

    echo "mv gfs userhome"
    parallel-ssh -H n02 mv /gfs-sata/$(echo "$USER" | tr -d '\r') /gfs-sata/to_be_delete/$(echo "$USER" | tr -d '\r')

  fi
done < $1

 echo "delete userhome in nvme and gfs"
parallel-ssh -H n02 rm -rf /gfs-sata/to_be_delete
