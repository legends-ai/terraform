#!/usr/bin/env python3

import json

services = [
    "alexandria", "charon", "helios", "legends.ai", "lucinda", "luna", "nova", "nova-queue", "vulgate"
]

fmt_str = "avg:docker.mem.in_use{{task_name:{0}}} * avg:docker.mem.limit{{task_name:{0}}}"

ddjson = {
    "viz": "timeseries",
    "requests": [{
        "aggregator": "avg",
        "conditional_formats": [],
        "q": ",".join((fmt_str.format(x) for x in services)),
        "type": "area"
    }],
    "autoscale": True
}

print(json.dumps(ddjson))
