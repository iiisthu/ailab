#!/bin/bash

kubectl apply -f ./cluster_setting

while IFS=, read USER EMAIL UIDD GIDD
do
  if [ -n "$(echo "$USER" | tr -d '\r')" ]; then
    echo "username : $(echo "$USER" | tr -d '\r')"	

    parallel-ssh -H n02 mkdir -p /gfs-sata/$(echo "$USER" | tr -d '\r')
    
    yamlfile=`cat ../values-template.yaml`
    all_variables="NAMESPACE=$(echo "$USER" | tr -d '\r') EMAIL=$(echo "$EMAIL" | tr -d '\r') UIDD=$(echo "$UIDD" | tr -d '\r') GIDD=$(echo "$GIDD" | tr -d '\r')"
    
    if [ ! -d "./yamls/" ];then
        mkdir ./yamls
    fi
    printf "$all_variables\ncat << EOF\n$yamlfile\nEOF" | bash > ./yamls/values_$(echo "$USER" | tr -d '\r').yaml

    helm install admin-$(echo "$USER" | tr -d '\r') \
      --namespace=$(echo "$USER" | tr -d '\r') \
      --create-namespace \
      --values ./yamls/values_$(echo "$USER" | tr -d '\r').yaml \
      ./adminchart
    sleep 10
    helm install gfshome-$(echo "$USER" | tr -d '\r') \
      --namespace=$(echo "$USER" | tr -d '\r') \
      --create-namespace \
      --values ./yamls/values_$(echo "$USER" | tr -d '\r').yaml \
      ./gfshomechart
    
    helm install user-$(echo "$USER" | tr -d '\r') \
      --namespace=$(echo "$USER" | tr -d '\r') \
      --values ./yamls/values_$(echo "$USER" | tr -d '\r').yaml \
      ../user/userchart
    sleep 20
  fi
done < $1
