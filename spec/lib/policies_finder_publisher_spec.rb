require "rails_helper"

RSpec.describe PoliciesFinderPublisher do
  let(:publisher) { described_class.new }

  describe "#exportable_attributes" do
    it "validates against govuk-content-schema" do
      expect(publisher.exportable_attributes.as_json).to be_valid_against_schema('finder')
    end
  end
end
