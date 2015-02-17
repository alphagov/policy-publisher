require "rails_helper"
require 'gds_api/test_helpers/publishing_api'

RSpec.describe PolicyArea do
  include GdsApi::TestHelpers::PublishingApi

  before do
    stub_default_publishing_api_put
  end

  it "automatically adds a slug on creation" do
    policy_area = PolicyArea.create!(name: "Climate change")

    expect(policy_area.slug).to eq("climate-change")
  end

  it "doesn't change the slug when the name changes" do
    policy_area = FactoryGirl.create(:policy_area, name: "Climate change")

    policy_area.name = "Immigration"
    policy_area.save!

    expect(policy_area.slug).to eq("climate-change")
  end

  it "doesn't permit blank names" do
    blank_policy_area = FactoryGirl.build(:policy_area, name: '')
    nil_policy_area = FactoryGirl.build(:policy_area, name: nil)

    expect(blank_policy_area).not_to be_valid
    expect(nil_policy_area).not_to be_valid
  end

  it "enforces unique names" do
    PolicyArea.create!(name: "Climate change")
    duplicate_policy_area = PolicyArea.new(name: "Climate change")

    expect(duplicate_policy_area).not_to be_valid
  end

  it "enforces unique slugs" do
    global_warming = PolicyArea.create!(name: "Global warming")
    global_warming.name = "Climate change"
    global_warming.save!

    new_global_warming = PolicyArea.new(name: "Global warming")

    expect(new_global_warming).not_to be_valid
  end

  it "publishes a Content Item after save" do
    policy_area = PolicyArea.create!(name: "Climate change")
    base_path = "/government/policies/#{policy_area.slug}"

    assert_publishing_api_put_item(
      base_path,
      {
        "format" => "policy_area",
        "rendering_app" => "finder-frontend",
        "publishing_app" => "policy-publisher",
      }
    )
  end
end
