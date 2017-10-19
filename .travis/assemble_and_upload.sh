#!/bin/bash
set -ev

./gradlew shadowJar generatePomFileForMavenPublication

curl -u $SONATYPE_SNAPSHOTS_USERNAME:$SONATYPE_SNAPSHOTS_PASSWORD \
	 --upload-file build/publications/maven/pom-default.xml \
	 --upload-file build/libs/google-java-format-gradle-plugin-0.7-SNAPSHOT.jar \
	 https://oss.sonatype.org/content/repositories/snapshots/com/github/sherter/googlejavaformatgradleplugin/google-java-format-gradle-plugin/travis-builds/$TRAVIS_BUILD_NUMBER.{pom,jar}
