#!/usr/bin/env bash

# Relaunch all of our services.
tf taint aws_ecs_service.alexandria
tf taint aws_ecs_service.charon
tf taint aws_ecs_service.helios
tf taint aws_ecs_service.legends-ai
tf taint aws_ecs_service.lucinda
tf taint aws_ecs_service.luna
tf taint aws_ecs_service.nova
tf taint aws_ecs_service.vulgate
