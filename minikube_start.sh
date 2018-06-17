#!/bin/bash -e

minikube delete || ERROR_LOVEL=0
minikube start \
  --kubernetes-version=v1.8.0 \
  --memory=6000 \
  --disk-size=50g \
  --bootstrapper=kubeadm \
  --extra-config=kubelet.authentication-token-webhook=true \
  --extra-config=kubelet.authorization-mode=Webhook \
  --extra-config=scheduler.address=0.0.0.0 \
  --extra-config=controller-manager.address=0.0.0.0
