require "rails_helper"
require 'spec/support/publishing_api_content_helpers'

RSpec.describe Policy do
  include PublishingApiContentHelpers

  it "automatically generates a slug on creation" do
    policy = FactoryBot.create(:policy, name: "Climate change")

    expect(policy.slug).to eq("climate-change")
  end

  it "doesn't change the slug when the name changes" do
    policy = FactoryBot.create(:policy, name: "Climate change")

    policy.name = "Immigration"
    policy.save!

    expect(policy.slug).to eq("climate-change")
  end

  it "doesn't permit blank names" do
    blank_policy = FactoryBot.build(:policy, name: '')
    nil_policy = FactoryBot.build(:policy, name: nil)

    expect(blank_policy).not_to be_valid
    expect(nil_policy).not_to be_valid
  end

  it "enforces unique names" do
    FactoryBot.create(:policy, name: "Climate change")
    duplicate_policy = FactoryBot.build(:policy, name: "Climate change")

    expect(duplicate_policy).not_to be_valid
  end

  it "enforces unique slugs" do
    global_warming = FactoryBot.create(:policy, name: "Global warming")
    global_warming.name = "Climate change"
    global_warming.save!

    new_global_warming = FactoryBot.build(:policy, name: "Global warming")

    expect(new_global_warming).not_to be_valid
  end

  it "can have a bi-directional relationship with other policies" do
    related_policy = FactoryBot.create(:policy)
    policy = FactoryBot.create(:policy, related_policies: [related_policy])

    expect([related_policy]).to eq(policy.related_policies)
    expect([policy]).to eq(related_policy.reload.parent_policies)
  end

  it "is a programme if it has a parent policy" do
    parent_policy = FactoryBot.create(:policy)
    policy = FactoryBot.create(:policy)

    expect(policy.sub_policy?).to be(false)

    policy.parent_policies << parent_policy
    expect(policy.sub_policy?).to be(true)
  end

  it "has a setter that can identify a new Policy as a programme" do
    policy = Policy.new(sub_policy: true)

    expect(policy.sub_policy?).to be(true)
  end

  it "cannot be associated with itself" do
    policy = FactoryBot.create(:policy)

    expect { policy.related_policies = [policy] }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "gets a list of applicable nations" do
    policy = FactoryBot.create(
      :policy,
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
    policy = FactoryBot.build(
      :policy,
      northern_ireland: false,
      northern_ireland_policy_url: "bad-url",
    )

    expect(policy).not_to be_valid
    expect(policy.errors.messages).to eq(northern_ireland: ["must have a valid alternative policy URL"])
  end

  it "allows valid alternative policy URLs" do
    policy = FactoryBot.build(
      :policy,
      northern_ireland: false,
      northern_ireland_policy_url: "http://example.ni",
    )

    expect(policy).to be_valid
  end

  it "allows specifying no alternative policy URL" do
    policy = FactoryBot.build(
      :policy,
      northern_ireland: false,
    )

    expect(policy).to be_valid
  end
end
