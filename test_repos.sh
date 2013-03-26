#!/bin/bash

set -ex

mkdir -p test_repos

if [ ! -d ./test_repos/git ];
then
    git clone git://github.com/milkypostman/melpa.git test_repos/git
fi

if [ ! -d ./test_repos/svn ];
then
    svn checkout http://js2-mode.googlecode.com/svn/trunk/ test_repos/svn
fi
