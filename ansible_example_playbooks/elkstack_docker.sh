#!/bin/bash
docker run -d \
  -p 9200:9200 \
  --name elasticsearch \
  --net=my-net \
  mrlesmithjr/elasticsearch:2.1
docker run -d \
  -p 5601:5601 \
  --name kibana \
  --net=my-net \
  mrlesmithjr/elk-kibana:4.3.1
docker run -d \
  -p 6379:6379 \
  --name redis \
  --net=my-net \
  mrlesmithjr/redis
docker run -d \
  -p 514:514 \
  -p 514:514/udp \
  -p 1515:1515 \
  -p 3515:3515 \
  -p 3525:3525 \
  -p 10514:10514 \
  --name elk-pre-processor \
  --net=my-net \
  mrlesmithjr/elk-pre-processor:2.1
docker run -d \
  --name elk-processor \
  --net=my-net \
  mrlesmithjr/elk-processor:2.1

