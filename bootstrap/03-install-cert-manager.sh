#!/usr/bin/env bash
set -euo pipefail

echo "==> cert-manager 설치 (Helm)"
if ! command -v helm >/dev/null 2>&1; then
  curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

helm repo add jetstack https://charts.jetstack.io
helm repo update
helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager --create-namespace \
  --set crds.enabled=true \
  --set resources.requests.cpu=10m \
  --set resources.requests.memory=32Mi

echo "==> cert-manager 파드 기동 대기"
kubectl -n cert-manager rollout status deployment/cert-manager --timeout=180s
kubectl -n cert-manager rollout status deployment/cert-manager-webhook --timeout=180s

echo "==> ClusterIssuer 적용 (argocd/cluster-issuer.yml 의 email 을 본인 이메일로 먼저 수정하세요)"
kubectl apply -f ../argocd/cluster-issuer.yml

echo "==> 완료. 이후 각 앱 ingress.yml 에 cert-manager.io/cluster-issuer: letsencrypt-prod 주석을 달면 자동으로 인증서가 발급됩니다."
