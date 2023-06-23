#!/usr/bin/env bash

set -e

if [ -z "$ARGOCD_APP_NAME" ]; then
    echo "ERROR: variable ARGOCD_APP_NAME is unset !" >&2; exit 1
fi
if [ -z "$ARGOCD_APP_NAMESPACE" ]; then
    echo "ERROR: variable ARGOCD_APP_NAMESPACE is unset !" >&2; exit 1
fi
if [ -z "$PARAM_ENV" ]; then
    echo "ERROR: variable PARAM_ENV is unset !" >&2; exit 1
fi
# if [ -z "$PRE_PROCESSING_PATH" ]; then
#     echo "ERROR: variable PRE_PROCESSING_PATH is unset !" >&2; exit 1
# fi

# template the noops helm package

noopsctl package helm template \
    -c $(cat environments/$PARAM_ENV/noops-version.yaml | yq -r '.chart') \
    --version $(cat environments/$PARAM_ENV/noops-version.yaml | yq -r '.version') \
    -n $ARGOCD_APP_NAMESPACE \
    -r $ARGOCD_APP_NAME \
    -e $PARAM_ENV \
    -z .
    # -z $PRE_PROCESSING_PATH
