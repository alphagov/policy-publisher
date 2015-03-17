require "schema_spec_helper"
require "publishers/policies_finder_publisher"

RSpec.describe PoliciesFinderPublisher do
  let(:publisher) { described_class.new }

  describe "#exportable_attributes" do
    it "validates against govuk-content-schema" do
      expect(publisher.exportable_attributes.to_json).to be_valid_against_schema('finder')
    end
  end
end
