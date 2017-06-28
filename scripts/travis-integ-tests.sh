#!/bin/bash

# This script runs the integration tests against multiple Gradle versions.
# It is used in the travis 'script' step (see ../.travis.yml).

IFS=',' read -r -a versions_array <<< "$GRADLE_VERSIONS"

if [[ "$TRAVIS_JDK_VERSION" != "openjdk7" ]]; then
	jdk_switcher use openjdk7
fi

(set -x; ./gradlew publishToMavenLocal)

if [[ "$TRAVIS_JDK_VERSION" != "openjdk7" ]]; then
	jdk_switcher use $TRAVIS_JDK_VERSION
fi


for element in "${versions_array[@]}"; do
	echo "*********************************************************************************"
	(set -x; GRADLE_VERSION="$element" ./gradlew integrationTest --exclude-task publishToMavenLocal)
	echo "*********************************************************************************"
done
