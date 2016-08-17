#!/bin/bash -xe
export REPO_NAME=${REPO_NAME:-"alphagov/policy-publisher"}
export CONTEXT_MESSAGE=${CONTEXT_MESSAGE:-"default"}
export GH_STATUS_GIT_COMMIT=${SCHEMA_GIT_COMMIT:-${GIT_COMMIT}}
export PRECOMPILE_ASSETS="yes"

curl https://raw.githubusercontent.com/alphagov/govuk-ci-scripts/master/rails-app.sh | bash
