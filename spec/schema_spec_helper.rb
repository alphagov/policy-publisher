require 'spec_helper'
require 'govuk-content-schema-test-helpers'
require 'govuk-content-schema-test-helpers/rspec_matchers'

GovukContentSchemaTestHelpers.configure do |config|
  config.schema_type = 'publisher'
  config.project_root = File.absolute_path(File.join(File.basename(__FILE__), '..'))
end

RSpec.configure do |config|
  config.include GovukContentSchemaTestHelpers::RSpecMatchers
end
