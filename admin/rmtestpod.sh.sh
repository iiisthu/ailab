#!/bin/bash

while IFS=, read USER EMAIL UIDD GIDD
do
  username=$(echo "$USER" | tr -d '\r')
  if [ -n "$username" ]; then
    echo "username : $username"	
    
    testuser=$(helm list --namespace=$username)
    echo $testuser
    
    if [[ ($testuser =~ "testuser-${username}") && ($testuser =~ "deployed")]]
    then
        echo "包含"
        echo "testuser-${username}"
        podtest=$(kubectl get pods -n=$username)
        echo $podtest
        if [[ ($podtest =~ "testuser-${username}") && ($podtest =~ "Running")]]
        then 
            echo "success create pod, delete helm release testuser-${username}"
            helm delete testuser-${username} --namespace=$username
        else
            echo "create pod error, please check pod"
            echo $podtest
        fi
    else
        echo "create helm release error, please check helm"
        echo $testuser
    fi
  fi
done < $1
