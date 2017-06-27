#!/bin/bash
set -e

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

set -o xtrace
for element in "${versions_array[@]}"; do
	GRADLE_VERSION="$element" ./gradlew --no-daemon integrationTest --exclude-task publishToMavenLocal
done
