#!/usr/bin/env bash

# ------------------------------------------------------------------------
# Copyright 2017 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License
# ------------------------------------------------------------------------

# methods
function echoBold () {
    echo $'\e[1m'"${1}"$'\e[0m'
}

# integrator
echoBold 'Un-deploying WSO2 Integrator...'
kubectl delete -f ../integrator-deployment.yaml
kubectl delete -f ../integrator-gateway-service.yaml
kubectl delete -f ../integrator-service.yaml

echoBold 'Un-deploying Ingresses...'
kubectl delete -f ../ingresses/integrator-ingress.yaml
kubectl delete -f ../ingresses/integrator-gateway-ingress.yaml

# databases
echoBold 'Un-deploying WSO2 Integrator Databases...'
kubectl delete -f rdbms/mysql/mysql-deployment.yaml
kubectl delete -f rdbms/mysql/mysql-service.yaml

# ConfigMaps
echoBold 'Deleting ConfigMaps...'
kubectl delete configmap integrator-conf
kubectl delete configmap integrator-conf-axis2
kubectl delete configmap integrator-conf-datasources
kubectl delete configmap mysql-dbscripts

# Persistent storage
echoBold 'Deleting persistent volume and volume claim...'
kubectl delete -f ../integrator-volume-claim.yaml
kubectl delete -f ../volumes/persistent-volumes.yaml

# delete the created Kubernetes Namespace
kubectl delete namespace wso2
sleep 40s

# switch the context to default namespace
kubectl config set-context $(kubectl config current-context) --namespace=default

echoBold 'Finished'
