#!/bin/bash
docker rmi $(docker images weblogic-serverless -q)
