#!/bin/bash
# Script to clean up and redeploy ansvue to fix duplicate port names

set -e

echo "Deleting existing deployment and service..."
kubectl delete deployment ansvue -n default --ignore-not-found=true
kubectl delete service ansvue -n default --ignore-not-found=true

echo "Waiting for resources to be deleted..."
sleep 2

echo "Applying new configuration..."
kubectl apply -k .

echo "Deployment successful!"
echo ""
echo "Checking status..."
kubectl get deployment ansvue -n default
kubectl get service ansvue -n default
echo ""
echo "Pods:"
kubectl get pods -n default -l app=ansvue
