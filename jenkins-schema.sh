#!/bin/bash -xe

export GOVUK_APP_DOMAIN=test.alphagov.co.uk
export GOVUK_ASSET_ROOT=http://static.test.alphagov.co.uk
export REPO_NAME="alphagov/govuk-content-schemas"
export CONTEXT_MESSAGE="Verify policy-publisher against content schemas"

exec ./jenkins.sh
