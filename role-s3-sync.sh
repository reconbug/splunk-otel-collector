#!/bin/bash

# helper script to upload cfn template files to be used as nested stacks
# requires awscli v2

# account ID defaults to the Cribl non-prod account
# AWS_ACCOUNT_ID=${1:="616401140035"}
ROLE_BUCKET="s3://${1}-it-oa-playbook-store-01"
ROLE_PATH="airotela"

echo "file upload details:"
echo "account id: ${AWS_ACCOUNT_ID}"
echo "template bucket path: ${TEMPLATE_BUCKET}/${TEMPLATE_PATH}"
echo "files:"
cd ./deployments/ansible/roles && ls

echo "beginning upload"
aws s3 sync . "${TEMPLATE_BUCKET}/${TEMPLATE_PATH}/"
SYNC_OUTPUT="$?"
aws s3 cp ../../../otel-playbook.yml "${TEMPLATE_BUCKET}/${TEMPLATE_PATH}/"

if [[ "$SYNC_OUTPUT" -eq 0 ]]; then
  echo "upload completed successfully"
else
  echo "aws s3 sync returned $SYNC_OUTPUT - verify template bucket contents"
