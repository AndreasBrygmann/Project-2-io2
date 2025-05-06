#!/bin/bash

set -euo pipefail

# Variables
ROOK_VERSION="v1.17.1"
ROOK_DIR="./rook"

# Ensure dependencies
echo "Checking for required tools..."

for cmd in git kubectl; do
  if ! command -v $cmd &>/dev/null; then
    echo "❌ $cmd is not installed. Please install it before running this script."
    exit 1
  fi
done

# Clone Rook repo
if [ ! -d "$ROOK_DIR" ]; then
  echo "Cloning Rook repository..."
  git clone --single-branch --branch "$ROOK_VERSION" https://github.com/rook/rook.git "$ROOK_DIR"
else
  echo "Rook repository already exists at $ROOK_DIR"
fi

cd "$ROOK_DIR/deploy/examples"

# Deploy Rook Ceph resources
echo "Applying CRDs, common resources, and operator..."
kubectl create -f crds.yaml -f common.yaml -f operator.yaml

echo "Creating Rook Ceph cluster..."
kubectl create -f cluster.yaml

echo "Waiting for rook-ceph pods to become ready..."
kubectl -n rook-ceph wait --for=condition=Ready pod --all --timeout=180s || {
  echo "Warning: Some pods may not have become ready in time."
}

echo "Reapplying cluster.yaml (optional)..."
kubectl create -f cluster.yaml || echo "cluster.yaml already applied."

echo "✅ Rook Ceph deployment complete."
