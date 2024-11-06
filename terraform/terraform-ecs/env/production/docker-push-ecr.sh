#!/bin/bash

docker pull < dockerhub image >

aws ecr get-login-password --region < region_here > | docker login --username AWS --password-stdin < ecr repo >

docker tag < image >:< tag > < ecr repo >:< tag > 

docker push < ecr repo >
