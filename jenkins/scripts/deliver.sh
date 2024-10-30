#!/usr/bin/env bash

echo 'The following Maven command installs your Maven-built Java application'
echo 'into the local Maven repository, which will ultimately be stored in'
echo 'Jenkins''s local Maven repository (and the "maven-repository" Docker data'
echo 'volume).'
set -x
mvn jar:jar install:install help:evaluate -Dexpression=project.name
set +x

echo 'The following command extracts the value of the <name/> element'
echo 'within <project/> of your Java/Maven project''s "pom.xml" file.'
set -x
NAME=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.name | sed 's/[^a-zA-Z0-9._-]//g')
set +x

echo 'The following command behaves similarly to the previous one but'
echo 'extracts the value of the <version/> element within <project/> instead.'
set -x
VERSION=$(mvn -q -DforceStdout help:evaluate -Dexpression=project.version | sed 's/[^a-zA-Z0-9._-]//g')
set +x

echo 'The following command runs and outputs the execution of your Java'
echo 'application (which Jenkins built using Maven) to the Jenkins UI.'

# Check if the jar file exists before attempting to run it
JAR_FILE="target/${NAME}-${VERSION}.jar"
if [[ -f "$JAR_FILE" ]]; then
    set -x
    java -jar "$JAR_FILE"
    set +x
else
    echo "Error: The jar file '$JAR_FILE' does not exist."
    exit 1
fi
