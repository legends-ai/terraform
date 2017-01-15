#!/usr/bin/env zsh

aws ecs describe-tasks --tasks \
    $(aws ecs list-tasks --region=us-east-1 \
          --cluster=dev | jq '.taskArns | join(" ")' \
             | sed -e 's/^"//' -e 's/"$//' \
    ) --region=us-east-1 --cluster=dev | jq '.tasks[] | select(.taskDefinitionArn | contains("nova"))'
