#!/bin/bash

# if error, stop
set -e

echo "Step 1: Clone Rook Repository"
cd ~
git clone --single-branch --branch release-1.11 https://github.com/rook/rook.git
cd rook/deploy/examples

echo "Step 2: Apply CRDs"
kubectl apply -f crds.yaml

echo "Step 3: Create Common Resources"
kubectl apply -f common.yaml

echo "Step 4: Deploy Rook Operator"
kubectl apply -f operator.yaml

echo "Waiting for rook-ceph-operator pod to be running..."
until kubectl get pods -n rook-ceph | grep rook-ceph-operator | grep Running; do
    sleep 5
    echo "Waiting..."
done

echo "Step 5: Deploy Ceph Cluster"
kubectl config set-context --current --namespace rook-ceph
kubectl apply -f cluster.yaml

echo "Waiting for Ceph Cluster to be Ready..."
until kubectl get cephcluster -n rook-ceph | grep -q 'HEALTH_OK'; do
    sleep 10
    echo "Waiting for HEALTH_OK..."
done

echo "Step 6: Deploy Toolbox"
kubectl apply -f toolbox.yaml

echo "Rook + Ceph cluster installation complete"
echo "You can now exec into the toolbox with:"
echo "kubectl -n rook-ceph exec -it deploy/rook-ceph-tools -- bash"
