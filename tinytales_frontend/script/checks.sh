#!/usr/bin/env bash
# fail if any commands fails
set -e
# make pipelines' return status equal the last command to exit with a non-zero status, or zero if all commands exit successfully
set -o pipefail
# debug log
set -x

echo "Running checks..."
IS_CI=${CI:-false}
echo "Is running on CI: $IS_CI"

# check if code is formatted properly
dart format --set-exit-if-changed --output=none .

# run static analysis
flutter analyze

# run custom lints (e.g. riverpod lints)
dart run custom_lint

# run tests
if [ -d "test/widget" ]; then
  echo "Running unit tests"
  flutter test test/widget --dart-define=CI=$IS_CI
fi

# check if test/unit exists
if [ -d "test/unit" ]; then
  echo "Running unit tests"
  flutter test test/unit --dart-define=CI=$IS_CI
fi

# no golden tests here due to the nature of the project
# check README.md for more information
