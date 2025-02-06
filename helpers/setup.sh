#!/usr/bin/zsh
# shellcheck disable=SC1090

# First, configure the correct repository commit template.
git config commit.template helpers/commit.txt

# Second, install FVM
curl -o- https://raw.githubusercontent.com/fvm-sh/fvm/v0.5.1/install.sh | bash

# Second, setup FVM
flutter pub global activate fvm
fvm use stable

# Third, run the CodeGen script for good measure so that the incoming developer
# does not face errors that he or she might not understand
./build.sh