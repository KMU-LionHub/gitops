# context-stt-gitops

Context STT 백엔드를 가비아 클라우드 서버(2vCore/4GB, 단일 노드) 위에 **k3s + ArgoCD App-of-Apps** 패턴으로 배포하기 위한 GitOps 저장소입니다.

## 구조

```
apps/         ArgoCD Application 정의 (App-of-Apps)
├── argocd.yml     -> argocd/  (ArgoCD가 스스로를 관리)
├── backend.yml    -> backend/ (Spring Boot API)
├── mysql.yml      -> mysql/   (MySQL 8)
├── prometheus.yml -> Helm 차트 직접 참조 (prometheus-community/prometheus)
└── grafana.yml    -> Helm 차트 직접 참조 (grafana/grafana)

argocd/       ArgoCD 네임스페이스, 프로젝트, UI Ingress, ClusterIssuer
backend/      Spring Boot 배포 (Deployment/Service/Ingress/ConfigMap)
mysql/        MySQL 배포 (Deployment/Service/PVC)
bootstrap/    서버에서 순서대로 실행하는 설치 스크립트
```

