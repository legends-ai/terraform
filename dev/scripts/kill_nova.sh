#!/usr/bin/env zsh
TASKS=`aws ecs list-tasks --region=us-east-1 --cluster=dev | jq '.taskArns | join(" ")' | sed -e 's/^"//' -e 's/"$//'`
echo $TASKS

TASK_INFO=`aws ecs describe-tasks --region=us-east-1 --cluster=dev --tasks $(echo $TASKS) | jq '.tasks[] | select(.taskDefinitionArn | contains("nova"))'`
echo $TASK_INFO

TASK_ID=`echo $TASK_INFO | jq .taskArn`
echo $TASK_ID

aws ecs stop-task --region=us-east-1 --cluster=dev --reason "Kill switch" --task $TASK_ID
