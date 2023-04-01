#!/usr/bin/env bash
set -e
set -x

echo -n "Setup environment: "
cat <<EOT >> "${WORKSPACE}"/.env

###> symfony/framework-bundle ###
APP_SECRET="${SYMF_PSYCHORAMA_APP_SECRET}"
###< symfony/framework-bundle ###

###> psychorama/git ###
DEFAULT_REPOSITORY_DIR=/var/www/app/private/
###< psychorama/git ###
EOT
echo "Done"
