#!/bin/bash

# This script runs the integration tests against multiple Gradle versions.
# It is used in the travis 'script' step (see ../.travis.yml).

IFS=',' read -r -a versions_array <<< "$GRADLE_VERSIONS"

echo
echo
echo "*********************************************************************************"
echo "This job runs the integration tests against the following versions of Gradle:"
joint_versions=$(printf ", %s" "${versions_array[@]}")
echo "${joint_versions:2}"
echo "*********************************************************************************"
echo
echo

if [[ "$TRAVIS_JDK_VERSION" != "openjdk7" ]]; then
	jdk_switcher use openjdk7
fi

./gradlew publishToMavenLocal

if [[ "$TRAVIS_JDK_VERSION" != "openjdk7" ]]; then
	jdk_switcher use $TRAVIS_JDK_VERSION
fi


for element in "${versions_array[@]}"; do
	true "****************************************************************************"
	GRADLE_VERSION="$element" ./gradlew integrationTest --exclude-task publishToMavenLocal
	true "****************************************************************************"
done
