#!/bin/bash

set -eo pipefail

xcodebuild -scheme Fracker \
            -sdk iphoneos \
            -configuration AppStoreDistribution \
            -archivePath $PWD/build/Fracker.xcarchive \
            clean archive | xcpretty
