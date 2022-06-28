#!/bin/bash

set -eo pipefail

xcodebuild -scheme Fracker \
            -sdk iphoneos \
            -configuration Release \
            -archivePath $PWD/build/Fracker.xcarchive \
            clean archive | xcpretty
