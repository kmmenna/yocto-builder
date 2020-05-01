#!/bin/bash

USER_ID=$(stat -c '%u' /bitbake)

if [ $USER_ID -ne 0 ]; then
    usermod -u $USER_ID build
    exec sudo -iu build /exec_at.sh "$PWD" "$@"
else
    exec "$@"
fi