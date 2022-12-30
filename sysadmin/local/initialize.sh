#!/usr/bin/env bash

echo "Starting up docker."
curl --fail -sS https://bitbucket.org/phpro/phpro-kevin/raw/master/get.sh | bash
kevin pull -q
kevin up -d

echo "Running composer install."
kevin composer install
