#!/bin/bash

set -eo pipefail

xcodebuild -archivePath $PWD/build/Fracker.xcarchive \
            -exportOptionsPlist Fracker/Supporting/ExportOptions.plist \
            -exportPath $PWD/build \
            -allowProvisioningUpdates \
            -exportArchive | xcpretty
