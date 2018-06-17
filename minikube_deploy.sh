#!/bin/bash -e

export K8S_VERSION="1.8.0"

while [[ $# -gt 0 ]]
do
  key="$1"

  case $key in
    storage-classes)
    echo -e "\033[32m"
    echo -e "DEPLOYING AWS STORAGE CLASSES"
    echo -e "\033[0m"
    kubectl config use-context minikube
    kubectl apply -f ./manifests/${K8S_VERSION}/storage-classes.yaml
    shift
    ;;

    ingress)
    echo -e "\033[32m"
    echo -e "DEPLOYING NGINX INGRESS"
    echo -e "\033[0m"
    kubectl config use-context minikube
    kubectl apply -f ./manifests/${K8S_VERSION}/ingress.yaml
    shift
    ;;
    
    dashboard)
    echo -e "\033[32m"
    echo -e "DEPLOYING KUBERNETES DASHBOARD"
    echo -e "\033[0m"
    kubectl config use-context minikube
    kubectl apply -f ./manifests/${K8S_VERSION}/dashboard.yaml
    shift
    ;;

    monitoring)
    echo -e "\033[32m"
    echo -e "DEPLOYING PROMETHEUS-OPERATOR WITH GRAFANA"
    echo -e "\033[0m"
    kubectl config use-context minikube
    kubectl apply -f ./manifests/${K8S_VERSION}/monitoring/00namespace-namespace.yaml
    for file in $(ls ./manifests/${K8S_VERSION}/monitoring/config-maps); do
      kubectl create configmap $file \
        --from-file=./manifests/${K8S_VERSION}/monitoring/config-maps/$file \
        --namespace=monitoring 2>/dev/null || \
        kubectl create configmap $file \
          --from-file=./manifests/${K8S_VERSION}/monitoring/config-maps/$file \
          --dry-run -o yaml \
          --namespace=monitoring | kubectl replace --namespace=monitoring -f -
    done
    
    kubectl apply -f ./manifests/${K8S_VERSION}/monitoring
    shift
    ;;

    logging)
    echo -e "\033[32m"
    echo -e "DEPLOYING FLUENTD WITH GRAYLOG2"
    echo -e "\033[0m"
    kubectl config use-context minikube
    kubectl apply -f ./manifests/${K8S_VERSION}/logging
    shift
    ;;

    base)
    "${BASH_SOURCE[0]}" storage-classes ingress dashboard monitoring logging
    shift
    ;;
  esac
done
