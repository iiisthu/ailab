#!/bin/bash

while IFS=, read USER EMAIL UIDD GIDD
do
  username=$(echo "$USER" | tr -d '\r')
  if [ -n "$username" ]; then
    echo "username : $username"	
    
    yamlfile=`cat ./values-template.yaml`
    all_variables="NAMESPACE=$username EMAIL=$(echo "$EMAIL" | tr -d '\r')"
    
    if [ ! -d "./yamls/" ];then
        mkdir ./yamls
    fi
    printf "$all_variables\ncat << EOF\n$yamlfile\nEOF" | bash > ./yamls/values_$username.yaml

    kubectl create namespace $username

    helm install admin-$username \
      --namespace=admin-helm \
      --create-namespace \
      --values ./yamls/values_$username.yaml \
      ./adminchart

    helm install gfshome-$username \
      --namespace=admin-helm \
      --create-namespace \
      --values ./yamls/values_$username.yaml \
      ./gfshomechart

    helm install gfsshare-$username \
      --namespace=admin-helm \
      --create-namespace \
      --values ./yamls/values_$username.yaml \
      ./gfssharechart
    
    helm install ssdshare-$username \
      --namespace=admin-helm \
      --create-namespace \
      --values ./yamls/values_$username.yaml \
      ./ssdsharechart
    
     testuser=$(helm install testuser-$username \
       --namespace=$username \
       --values ./yamls/values_$username.yaml \
       ../user/userchart)

    if [[ ($testuser =~ $username)  && ($testuser =~ "deployed")]]
    then
        echo "成功 创建用户 $username"
    else
        echo "失败 创建用户 $username"
    fi

  fi
done < $1
