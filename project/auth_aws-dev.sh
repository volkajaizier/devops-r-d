#!/bin/bash
AWS_CLI=`which aws`
if [ $? -ne 0 ]; then
  echo "AWS CLI is not installed; exiting"
  exit 1
else
  echo "Using AWS CLI found at $AWS_CLI"
fi
if [ $# -ne 2 ]; then
  echo "Usage: $0  <IAM_USER> <MFA_TOKEN_CODE> aws_user_profile aws_2auth_profile"
  echo "Where:"
  echo "   <IAM_USER> = IAM user name"
  echo "   <MFA_TOKEN_CODE> = Code from virtual MFA device"
  exit 2
fi
AWS_USER_PROFILE=dev
AWS_2AUTH_PROFILE=dev-2auth
ARN_OF_MFA=arn:aws:iam::817539924586:mfa/$1
MFA_TOKEN_CODE=$2
DURATION=129600
echo "AWS-CLI Profile: $AWS_CLI_PROFILE"
echo "MFA ARN: $ARN_OF_MFA"
echo "MFA Token Code: $MFA_TOKEN_CODE"
set -x
read AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN <<< \
$( aws --profile $AWS_USER_PROFILE sts get-session-token \
  --duration $DURATION  \
  --serial-number $ARN_OF_MFA \
  --token-code $MFA_TOKEN_CODE \
  --output text  | awk '{ print $2, $4, $5 }')
echo "AWS_ACCESS_KEY_ID: " $AWS_ACCESS_KEY_ID
echo "AWS_SECRET_ACCESS_KEY: " $AWS_SECRET_ACCESS_KEY
echo "AWS_SESSION_TOKEN: " $AWS_SESSION_TOKEN
if [ -z "$AWS_ACCESS_KEY_ID" ]
then
  exit 1
fi
`aws --profile $AWS_2AUTH_PROFILE configure set aws_access_key_id "$AWS_ACCESS_KEY_ID"`
`aws --profile $AWS_2AUTH_PROFILE configure set aws_secret_access_key "$AWS_SECRET_ACCESS_KEY"`
`aws --profile $AWS_2AUTH_PROFILE configure set aws_session_token "$AWS_SESSION_TOKEN"`
