#!/bin/bash
set -euo pipefail

if [[ $TRAVIS_OS_NAME = "linux" ]]
then
    # run CentOS5 based docker container
    docker run -e SUBDAG -e SUBDAGS -e TRAVIS_BRANCH -e TRAVIS_PULL_REQUEST -e ANACONDA_TOKEN -v `pwd`:/bioconda-recipes bioconda/bioconda-builder
    #if [ "$TESTALL" = true && $TRAVIS_BRACH = "master" ]
    if [ "$TESTALL" = true ]
    then
        docker run -v `pwd`:/bioconda-recipes bioconda/bioconda-builder --testonly
    fi
    # Build package documentation
    ./scripts/build-docs.sh
else
    export PATH=/anaconda/bin:$PATH
    # build packages
    scripts/build-packages.py --repository .
    #if [ "$TESTALL" = true && $TRAVIS_BRACH = "master" ]
    if [ "$TESTALL" = true ]
    then
        scripts/build-packages.py --repository . --testonly
    fi
fi
