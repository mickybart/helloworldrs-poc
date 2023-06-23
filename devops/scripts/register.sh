#!/usr/bin/env bash

set -e

cat << EOF
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: helloworldrs
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/mickybart/helloworldrs-poc.git
    targetRevision: delivery
    path: .
    plugin:
      parameters:
      - name: mode
        string: root
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd
  syncPolicy:
    automated:
      prune: true
EOF
