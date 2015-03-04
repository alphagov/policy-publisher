require "rails_helper"

RSpec.describe PoliciesFinderPublisher do

  let(:publisher) { described_class.new }

  describe "#exportable_attributes" do
    it "validates against govuk-content-schema" do
      attrs = publisher.exportable_attributes
      validator = GovukContentSchema::Validator.new("finder", attrs.to_json)
      assert validator.valid?, "JSON not valid against finder schema: #{validator.errors.to_s}"
    end
  end
end
