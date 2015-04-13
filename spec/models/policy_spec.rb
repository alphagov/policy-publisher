require "rails_helper"
require 'gds_api/test_helpers/publishing_api'
require 'gds_api/test_helpers/rummager'

RSpec.describe Policy do
  include GdsApi::TestHelpers::PublishingApi
  include GdsApi::TestHelpers::Rummager

  before do
    stub_default_publishing_api_put
    stub_any_rummager_post
  end

  it "automatically generates a slug on creation" do
    policy = FactoryGirl.create(:policy, name: "Climate change")

    expect(policy.slug).to eq("climate-change")
  end

  it "doesn't change the slug when the name changes" do
    policy = FactoryGirl.create(:policy, name: "Climate change")

    policy.name = "Immigration"
    policy.save!

    expect(policy.slug).to eq("climate-change")
  end

  it "doesn't permit blank names" do
    blank_policy = FactoryGirl.build(:policy, name: '')
    nil_policy = FactoryGirl.build(:policy, name: nil)

    expect(blank_policy).not_to be_valid
    expect(nil_policy).not_to be_valid
  end

  it "enforces unique names" do
    FactoryGirl.create(:policy, name: "Climate change")
    duplicate_policy = FactoryGirl.build(:policy, name: "Climate change")

    expect(duplicate_policy).not_to be_valid
  end

  it "enforces unique slugs" do
    global_warming = FactoryGirl.create(:policy, name: "Global warming")
    global_warming.name = "Climate change"
    global_warming.save!

    new_global_warming = FactoryGirl.build(:policy, name: "Global warming")

    expect(new_global_warming).not_to be_valid
  end

  it "publishes a Content Item after save" do
    policy = FactoryGirl.create(:policy, name: "Climate change")

    assert_publishing_api_put_item(
      policy.base_path,
      {
        "format" => "policy",
        "rendering_app" => "finder-frontend",
        "publishing_app" => "policy-publisher",
      }
    )
  end

  it "adds a Document to Rummager after save" do
    policy = FactoryGirl.create(:policy, name: "Climate change")

    expected_json = JSON.parse({
      title: policy.name,
      description: policy.description,
      link: policy.base_path,
      indexable_content: "",
      organisations: [],
      last_update: policy.updated_at,
      _type: "policy",
      _id: policy.base_path,
    }.to_json)
    assert_rummager_posted_item(expected_json)
  end

  it "gets a list of applicable nations" do
    policy = FactoryGirl.create(
      :policy,
      name: "Rural payments",
      northern_ireland: false,
      northern_ireland_policy_url: "https://www.nidirect.gov.uk",
      scotland: false,
      scotland_policy_url: "http://www.gov.scot/",
      wales: false,
      wales_policy_url: "http://gov.wales/",
    )

    expect(policy.applicable_nations).to eq([:england])
  end

  it "doesn't allow invalid alternative policy URLs" do
    policy = FactoryGirl.build(
      :policy,
      name: "Rural payments",
      northern_ireland: false,
      northern_ireland_policy_url: "bad-url",
    )

    expect(policy).not_to be_valid
    expect(policy.errors.messages).to eq({:northern_ireland=>["must have a valid alternative policy URL"]})
  end

  it "allows valid alternative policy URLs" do
    policy = FactoryGirl.build(
      :policy,
      name: "Rural payments",
      northern_ireland: false,
      northern_ireland_policy_url: "http://example.ni",
    )

    expect(policy).to be_valid
  end

  it "allows specifying no alternative policy URL" do
    policy = FactoryGirl.build(
      :policy,
      name: "Rural payments",
      northern_ireland: false,
    )

    expect(policy).to be_valid
  end
end