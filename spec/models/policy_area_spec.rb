require "rails_helper"
require 'gds_api/test_helpers/publishing_api'
require 'gds_api/test_helpers/rummager'

RSpec.describe PolicyArea do
  include GdsApi::TestHelpers::PublishingApi
  include GdsApi::TestHelpers::Rummager

  before do
    stub_default_publishing_api_put
    stub_any_rummager_post
  end

  it "automatically adds a slug on creation" do
    policy_area = FactoryGirl.create(:policy_area, name: "Climate change")

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
    FactoryGirl.create(:policy_area, name: "Climate change")
    duplicate_policy_area = FactoryGirl.build(:policy_area, name: "Climate change")

    expect(duplicate_policy_area).not_to be_valid
  end

  it "enforces unique slugs" do
    global_warming = FactoryGirl.create(:policy_area, name: "Global warming")
    global_warming.name = "Climate change"
    global_warming.save!

    new_global_warming = FactoryGirl.build(:policy_area, name: "Global warming")

    expect(new_global_warming).not_to be_valid
  end

  it "publishes a Content Item after save" do
    policy_area = FactoryGirl.create(:policy_area, name: "Climate change")
    base_path = "/government/policies/#{policy_area.slug}"

    assert_publishing_api_put_item(
      base_path,
      {
        "format" => "policy",
        "rendering_app" => "finder-frontend",
        "publishing_app" => "policy-publisher",
      }
    )
  end

  it "adds a Document to Rummager after save" do
    policy_area = FactoryGirl.create(:policy_area, name: "Climate change")

    expected_json = JSON.parse({
      title: policy_area.name,
      description: policy_area.description,
      link: "/government/policies/#{policy_area.slug}",
      indexable_content: "",
      organisations: [],
      last_update: policy_area.updated_at,
      _type: "policy",
      _id: "/government/policies/#{policy_area.slug}",
    }.to_json)
    assert_rummager_posted_item(expected_json)
  end

  it "gets a list of applicable nations" do
    policy_area = FactoryGirl.create(
      :policy_area,
      name: "Rural payments",
      northern_ireland: false,
      northern_ireland_policy_url: "https://www.nidirect.gov.uk",
      scotland: false,
      scotland_policy_url: "http://www.gov.scot/",
      wales: false,
      wales_policy_url: "http://gov.wales/",
    )

    expect(policy_area.applicable_nations).to eq([:england])
  end

  it "doesn't allow invalid alternative policy URLs" do
    policy_area = FactoryGirl.build(
      :policy_area,
      name: "Rural payments",
      northern_ireland: false,
      northern_ireland_policy_url: "bad-url",
    )

    expect(policy_area).not_to be_valid
    expect(policy_area.errors.messages).to eq({:northern_ireland=>["must have a valid alternative policy URL"]})
  end

  it "allows valid alternative policy URLs" do
    policy_area = FactoryGirl.build(
      :policy_area,
      name: "Rural payments",
      northern_ireland: false,
      northern_ireland_policy_url: "http://example.ni",
    )

    expect(policy_area).to be_valid
  end

  it "allows specifying no alternative policy URL" do
    policy_area = FactoryGirl.build(
      :policy_area,
      name: "Rural payments",
      northern_ireland: false,
    )

    expect(policy_area).to be_valid
  end
end
