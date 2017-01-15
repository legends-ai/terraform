#!/usr/bin/env zsh

aws ecs stop-task --region=us-east-1 --cluster=dev \
  $(aws ecs describe-tasks --region=us-east-1 --cluster=dev --tasks \
    $(aws ecs list-tasks --region=us-east-1 --cluster=dev \
      | jq '.taskArns | join(" ")' \
      | sed -e 's/^"//' -e 's/"$//') \
    | jq '.tasks[] | select(.taskDefinitionArn | contains("nova"))'
)
