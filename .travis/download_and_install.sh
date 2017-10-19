#!/bin/bash
set -ev

(cd /tmp; curl -OO https://oss.sonatype.org/content/repositories/snapshots/com/github/sherter/googlejavaformatgradleplugin/google-java-format-gradle-plugin/travis-builds/$TRAVIS_BUILD_NUMBER.{pom,jar})
mvn install:install-file -Dfile=/tmp/$TRAVIS_BUILD_NUMBER.jar -DpomFile=/tmp/$TRAVIS_BUILD_NUMBER.pom
