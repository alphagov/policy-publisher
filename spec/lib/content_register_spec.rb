require "rails_helper"
require 'gds_api/test_helpers/content_register'

RSpec.describe ContentRegister do
  include GdsApi::TestHelpers::ContentRegister

  before do
    stub_content_register_entries("organisation", [org_1, org_2])
    stub_content_register_entries("person", [person])
  end

  let(:org_1) do
    {
      "content_id" => SecureRandom.uuid,
      "format" => "organisation",
      "title" => "Organisation 1",
      "base_path" => "/government/organisations/organisation-1",
    }
  end

  let(:org_2) do
    {
      "content_id" => SecureRandom.uuid,
      "format" => "organisation",
      "title" => "Organisation 2",
      "base_path" => "/government/organisations/organisation-2",
    }
  end

  let(:person) do
    {
      "content_id" => SecureRandom.uuid,
      "format" => "person",
      "title" => "A Person",
      "base_path" => "/government/organisations/a-person",
    }
  end

  describe "#organisation" do
    it "returns all entries for the 'organisation' format" do
      expect(ContentRegister.new.organisations).to eq([org_1, org_2])
    end
  end

  describe "#people" do
    it "returns all entries for the 'person' format" do
      expect(ContentRegister.new.people).to eql([person])
    end
  end
end
