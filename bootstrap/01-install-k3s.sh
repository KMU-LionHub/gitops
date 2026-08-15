#!/usr/bin/env bash
set -euo pipefail

echo "==> k3s 설치 (Traefik 인그레스, local-path-provisioner 내장)"
curl -sfL https://get.k3s.io | sh -

echo "==> kubectl 별칭 및 kubeconfig 권한 설정"
mkdir -p ~/.kube
cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
chmod 600 ~/.kube/config

echo "==> 노드 상태 확인"
k3s kubectl get nodes -o wide

echo "==> 완료. 아래 커맨드로 계속 진행하세요:"
echo "    kubectl get pods -A"
echo "    bash 02-install-argocd.sh"
