#!/usr/bin/env bash

set -e

if [ -z "$ARGOCD_APP_NAME" ]; then
    echo "ERROR: variable ARGOCD_APP_NAME is unset !" >&2; exit 1
fi
# if [ -z "$ARGOCD_APP_NAMESPACE" ]; then
#     echo "ERROR: variable ARGOCD_APP_NAMESPACE is unset !" >&2; exit 1
# fi
if [ -z "$ARGOCD_APP_SOURCE_REPO_URL" ]; then
    echo "ERROR: variable ARGOCD_APP_SOURCE_REPO_URL is unset !" >&2; exit 1
fi

function generators {
  for target_env in $(ls -1 ./environments/); do
      cat << EOF
  - clusters:
      selector:
        matchLabels:
          env-$target_env: 'true'
      values:
        env: $target_env
EOF
  done
}

cat << EOF
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: $ARGOCD_APP_NAME-all
spec:
  generators:
$(generators)
  template:
    metadata:
      name: $ARGOCD_APP_NAME-{{values.env}}-{{name}}
    spec:
      project: default
      source:
        repoURL: $ARGOCD_APP_SOURCE_REPO_URL
        targetRevision: delivery
        path: .
        plugin:
          parameters:
          - name: mode
            string: product
          - name: env
            string: '{{values.env}}'
      destination:
        server: '{{server}}'
        namespace: $ARGOCD_APP_NAME-{{values.env}}
      syncPolicy:
        automated:
          prune: true
        syncOptions:
        - CreateNamespace=true
EOF
