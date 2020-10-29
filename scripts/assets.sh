#!/bin/sh

set -e

DIR=`dirname $0`

flutter pub pub run daassets:daassets.dart ${DIR}/../example/pubspec.yaml ${DIR}/../example/assets.dart