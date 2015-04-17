require "rails_helper"

RSpec.describe PlaceholderContentItemPresenter do
  let(:policy) { FactoryGirl.create(:policy) }
  let(:presenter) { PlaceholderContentItemPresenter.new(policy) }

  describe "#exportable_attributes" do
    let(:attributes) { presenter.exportable_attributes.as_json }

    it "validates against the schema for a placeholder item" do
      expect(attributes).to be_valid_against_schema('placeholder')
    end

    it "includes the essential policy information" do
      expect(attributes["title"]).to eq(policy.name)
      expect(attributes["content_id"]).to eq(policy.content_id)
      expect(attributes["routes"][0]["path"]).to eq(policy.base_path)
      expect(attributes["routes"][0]["type"]).to eq("exact")
    end
  end
end
