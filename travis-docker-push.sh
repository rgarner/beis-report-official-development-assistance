#!/bin/bash
TAG="${TRAVIS_BRANCH}-${TRAVIS_BUILD_NUMBER}-${TRAVIS_COMMIT}"
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin
docker build -t "thedxw/beis-report-official-development-assistance:$TRAVIS_BRANCH" .
docker tag "thedxw/beis-report-official-development-assistance:$TRAVIS_BRANCH" "thedxw/beis-report-official-development-assistance:$TAG"
docker push "thedxw/beis-report-official-development-assistance:$TRAVIS_BRANCH"
docker push "thedxw/beis-report-official-development-assistance:$TAG"