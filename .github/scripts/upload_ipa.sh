#!/bin/bash

set -eo pipefail

xcrun altool --upload-app -t ios -f build/Fracker.ipa -u "$APPLEID_USERNAME" -p "$APPLEID_PASSWORD" --verbose
