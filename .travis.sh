#!/bin/bash
set -ev

echo "Running sinatra tests..."
bundle exec rake test

# Auto release tasks
cd sandbox
bundle install
bundle exec rake release:travis

if git diff --exit-code; then
  exit 0
fi

bundle exec rake release:all
