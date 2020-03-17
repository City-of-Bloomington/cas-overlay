#!/bin/bash
# Environment variables:
#   $WAR  The filename of the war file to be deployed
set -e

cp /var/kubernetes/services/*.* /etc/cas/services/

exec java -server -noverify -Xmx2048M -jar $WAR
