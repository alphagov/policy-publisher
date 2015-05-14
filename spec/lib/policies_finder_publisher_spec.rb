require "rails_helper"
require 'gds_api/test_helpers/content_register'

RSpec.describe PoliciesFinderPublisher do
  include GdsApi::TestHelpers::ContentRegister

  before do
    stub_content_register_entries("organisation", [org_1])
  end

  let(:org_1) do
    {
      "content_id" => SecureRandom.uuid,
      "format" => "organisation",
      "title" => "Organisation 1",
      "base_path" => "/government/organisations/organisation-1",
    }
  end

  let(:publisher) { described_class.new }

  describe "#exportable_attributes" do
    it "validates against govuk-content-schema" do
      expect(publisher.exportable_attributes.as_json).to be_valid_against_schema('finder')
    end

    it "contains the organisations tagged to policies" do
      policy = FactoryGirl.create(:policy, organisation_content_ids: [org_1["content_id"]])
      organisation_facet = publisher.exportable_attributes["details"][:facets][1]
      expect(organisation_facet[:allowed_values]).to match_array([{label: "Organisation 1", value: "organisation-1"}])
    end

  end
end
