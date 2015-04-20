require "schema_spec_helper"
require "publishers/policy_signup_page_publisher"
require "gds_api/test_helpers/publishing_api"
require "gds_api/test_helpers/rummager"

RSpec.describe PolicySignupPagePublisher do
  include GdsApi::TestHelpers::PublishingApi
  include GdsApi::TestHelpers::Rummager

  let(:publisher) { described_class.new(FactoryGirl.create(:policy)) }

  before do
    stub_default_publishing_api_put
    stub_any_rummager_post
  end

  describe "#exportable_attributes" do
    it "validates against govuk-content-schema" do
      expect(publisher.exportable_attributes.to_json).to be_valid_against_schema("email_alert_signup")
    end
  end
end
