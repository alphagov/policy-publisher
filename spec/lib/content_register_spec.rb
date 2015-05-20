require "rails_helper"
require 'gds_api/test_helpers/content_register'

RSpec.describe ContentRegister do
  include GdsApi::TestHelpers::ContentRegister

  before do
    stub_content_register_entries("organisation", [org_1, org_2])
    stub_content_register_entries("person", [person])
    stub_content_register_entries("working_group", working_groups)
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
      "base_path" => "/government/people/a-person",
    }
  end

  let(:working_groups) do
    [
      {
        "content_id" => SecureRandom.uuid,
        "format" => "working_group",
        "title" => "Working group 1",
        "base_path" => "/government/groups/working-group-1",
      },
      {
        "content_id" => SecureRandom.uuid,
        "format" => "working_group",
        "title" => "Working group 2",
        "base_path" => "/government/groups/working-group-2",
      },
    ]
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

  describe "#working_groups" do
    it "returns all entries for the 'working_group' format" do
      expect(ContentRegister.new.working_groups).to eql(working_groups)
    end
  end
end
