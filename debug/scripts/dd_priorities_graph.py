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

{
  "requests": [
    {
      "q": "avg:dev.nova.nova.queue.match.process.count{priority:2017/2/silver}, avg:dev.nova.nova.queue.match.process.count{priority:2017/2/platinum}",
      "type": "area",
      "conditional_formats": []
    }
  ],
  "viz": "timeseries",
  "autoscale": true
}

print(json.dumps(ddjson))
