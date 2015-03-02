#!/bin/bash -xe
export DISPLAY=:99
export RAILS_ENV=test
export REPO_NAME="alphagov/policy-publisher"

function github_status {
  REPO_NAME="$1"
  STATUS="$2"
  MESSAGE="$3"
  gh-status "$REPO_NAME" "$GIT_COMMIT" "$STATUS" -d "Build #${BUILD_NUMBER} ${MESSAGE}" -u "$BUILD_URL" >/dev/null
}

function error_handler {
  trap - ERR # disable error trap to avoid recursion
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo "Error on or near line ${parent_lineno}: ${message}; exiting with status ${code}"
  else
    echo "Error on or near line ${parent_lineno}; exiting with status ${code}"
  fi
  github_status "$REPO_NAME" failure "failed on Jenkins"
  exit "${code}"
}

trap "error_handler ${LINENO}" ERR
github_status "$REPO_NAME" pending "is running on Jenkins"

# Try to merge master into the current branch, and abort if it doesn't exit
# cleanly (ie there are conflicts). This will be a noop if the current branch
# is master.
git merge --no-commit origin/master || git merge --abort

bundle install --path "${HOME}/bundles/${JOB_NAME}" --deployment --without development
bundle exec rake db:reset
bundle exec rake assets:clean assets:precompile

# Clone govuk-content-schemas depedency for tests
rm -rf tmp/govuk-content-schemas
git clone git@github.com:alphagov/govuk-content-schemas.git tmp/govuk-content-schemas

RAILS_ENV=test GOVUK_CONTENT_SCHEMAS_PATH=tmp/govuk-content-schemas bundle exec rake


export EXIT_STATUS=$?

if [ "$EXIT_STATUS" == "0" ]; then
  github_status "$REPO_NAME" success "succeeded on Jenkins"
else
  github_status "$REPO_NAME" failure "failed on Jenkins"
fi

exit $EXIT_STATUS
