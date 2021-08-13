#!/bin/bash

if [[ -d .env ]]; then
 . env/bin/activate
else
 echo "Requires a virtual environment in ./env"
 exit 0
fi

function test_untracked_files() {
 # Get untracked files in migrations folder, potentially created from previous call
 UNTRACKED_FILES=$(git ls-files migrations --exclude-standard --others)

 # Fail in case there are untracked migrations
 if [[ ! -z "$UNTRACKED_FILES" ]]; then
  echo "There are untracked migrations required to the database. Please see:"
  echo $UNTRACKED_FILES
  exit 1
 fi
}

# Test if untracked migrations exist
test_untracked_files

# Run migration
python3 manage.py db migrate 2&>1 > /dev/null

# Test if untracked migrations exist
test_untracked_files
