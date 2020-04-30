#!/bin/bash
source params.env
message=$2
title=$1
curl --header 'Access-Token: $PBTOKEN' \
     --header 'Content-Type: application/json' \
     --data-binary '{"body":"'"$message"'","title":"'"$title"'","type":"note"}' \
     --request POST \
     https://api.pushbullet.com/v2/pushes
