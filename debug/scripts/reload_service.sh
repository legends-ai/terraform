#!/usr/bin/env bash

terraform taint aws_ecs_service.$1
