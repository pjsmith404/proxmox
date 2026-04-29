#!/bin/bash

BASE_URL="https://192.168.1.5:8006/api2/json/"

curl -k -H "Authorization: PVEAPIToken=root@pam!test=$API_TOKEN" "$BASE_URL/version"
