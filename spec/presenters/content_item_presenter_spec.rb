require "rails_helper"
require "gds_api/test_helpers/publishing_api"

RSpec.describe ContentItemPresenter do
  include GdsApi::TestHelpers::PublishingApi

  before do
    stub_default_publishing_api_put
  end

  let(:policy) {
    PolicyArea.create!(
      name: "Tea and biscuits",
      description: "Tea and biscuits are popular among many people who live in the UK.",
    )
  }

  let(:presenter) { ContentItemPresenter.new(policy) }

  describe "#exportable_attributes" do
    it "validates against the schema for a policy" do
      validator = GovukContentSchema::Validator.new('policy', presenter.exportable_attributes.as_json)
      assert validator.valid?, "JSON not valid against the 'policy' schema: #{validator.errors.to_s}"
    end
  end
end
