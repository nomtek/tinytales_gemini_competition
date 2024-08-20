#!/usr/bin/env bash
# fail if any commands fails
set -e
# make pipelines' return status equal the last command to exit with a non-zero status, or zero if all commands exit successfully
set -o pipefail
# debug log
set -x

# assumes flutter build web was run before this script
# assumes firebase is installed and project is initialized
# requires FIREBASE_TOKEN to be set in the environment

# left for debugging
# flutter pub get
# flutter build web

firebase deploy --only hosting --token $FIREBASE_TOKEN
