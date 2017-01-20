#!/usr/bin/env bash

# Relaunch all of our services.
terraform taint aws_ecs_service.alexandria
terraform taint aws_ecs_service.charon
terraform taint aws_ecs_service.dd-agent
terraform taint aws_ecs_service.helios
terraform taint aws_ecs_service.legends-ai
terraform taint aws_ecs_service.lucinda
terraform taint aws_ecs_service.luna
terraform taint aws_ecs_service.nova
terraform taint aws_ecs_service.vulgate
