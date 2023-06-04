#!/usr/bin/env bash

set -e

function usage {
    cat << EOF 1>&2

Usage: $(basename $0)

Run continuous integration for product.

The product must be a git repository.
Commit will be used to set the product version.

Environement variables expected:
--------------------------------
REPOSITORY            The repository name

EOF
    exit 1
}

echo "Running CI..."

if [ -z "$REPOSITORY" ]; then
    usage
fi

source /builder/modules/oci-registry-init

VERSION=sha-$(git rev-parse --short=7 HEAD)
TAG=$(registry_image_tag $REPOSITORY $VERSION)
DOCKERFILE=$(cat $NOOPS_GENERATED_JSON | jq -r .package.docker.product.dockerfile)

docker buildx build \
    --tag $TAG \
    --target builder \
    -f $DOCKERFILE .

echo "CI done with success"
