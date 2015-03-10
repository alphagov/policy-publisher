require "rails_helper"

RSpec.describe PoliciesFinderPublisher do

  let(:publisher) { described_class.new }

  describe "#exportable_attributes" do
    it "validates against govuk-content-schema" do
      assert_valid_against_schema publisher.exportable_attributes.as_json, "finder"
    end
  end
end
