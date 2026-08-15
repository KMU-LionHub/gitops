#!/usr/bin/env bash
set -euo pipefail

echo "==> argocd 네임스페이스 생성 및 ArgoCD 설치"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "==> ArgoCD 파드 기동 대기"
kubectl -n argocd rollout status deployment/argocd-server --timeout=180s

echo "==> App-of-Apps(apps/) 등록: 이 시점부터 apps/*.yml 이 ArgoCD Application으로 동기화됩니다"
kubectl apply -f ../apps/

echo "==> 초기 admin 비밀번호 (최초 1회 확인 후 반드시 변경하세요: argocd account update-password)"
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d
echo ""

echo "==> ArgoCD UI 접속: kubectl -n argocd port-forward svc/argocd-server 8080:443"
echo "    또는 argocd/ingress.yml 동기화 후 http://argocd.<PUBLIC_IP>.nip.io 로 접속"
