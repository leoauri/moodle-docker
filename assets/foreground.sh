#!/bin/bash

# pass environment to cron
declare -p | grep -Ev 'BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|UID' > /container.env
service cron start

# start letsencrypt certbot
if [ "$MOODLE_DOCKER_SSL" = true ]; then
    certbot --apache --non-interactive --agree-tos --no-redirect \
        -d "$MOODLE_DOCKER_WEB_HOST" -m "$MOODLE_DOCKER_ADMIN_EMAIL"
fi

if ! [ "$MOODLE_DOCKER_DEV_MODE" = true ]; then
    echo 'display_errors = Off' >> /usr/local/etc/php/php.ini
fi

apache2-foreground
