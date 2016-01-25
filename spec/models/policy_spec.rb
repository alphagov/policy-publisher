require "rails_helper"
require 'spec/support/publishing_api_content_helpers'

RSpec.describe Policy do
  include PublishingApiContentHelpers

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

  it "can have a bi-directional relationship with other policies" do
    related_policy = FactoryGirl.create(:policy)
    policy = FactoryGirl.create(:policy, related_policies: [related_policy])

    expect([related_policy]).to eq(policy.related_policies)
    expect([policy]).to eq(related_policy.reload.parent_policies)
  end

  it "is a programme if it has a parent policy" do
    parent_policy = FactoryGirl.create(:policy)
    policy = FactoryGirl.create(:policy)

    expect(policy.sub_policy?).to be(false)

    policy.parent_policies << parent_policy
    expect(policy.sub_policy?).to be(true)
  end

  it "has a setter that can identify a new Policy as a programme" do
    policy = Policy.new(sub_policy: true)

    expect(policy.sub_policy?).to be(true)
  end

  it "cannot be associated with itself" do
    policy = FactoryGirl.create(:policy)

    expect { policy.related_policies = [policy] }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "caches tagged organisations" do
    stub_content_calls_from_publishing_api

    policy = FactoryGirl.create(:policy,
      organisation_content_ids: [
        organisation_1['content_id'],
        organisation_2['content_id']
      ])

    expect(policy.organisations).to eq([organisation_1, organisation_2])

    policy.organisation_content_ids = {lead: [organisation_2['content_id'], supporting: organisation_1['content_id']] }

    expect(policy.organisations).to eq([organisation_1, organisation_2])

    first_read = policy.organisations.object_id
    second_read = policy.organisations.object_id
    expect(first_read).to eq(second_read)
  end

  it "caches tagged people" do
    stub_content_calls_from_publishing_api

    policy = FactoryGirl.create(:policy,
      people_content_ids: [
        person_1['content_id'],
        person_2['content_id']
      ])

    expect(policy.people).to eq([person_1, person_2])

    policy.people_content_ids = [person_2['content_id'], person_1['content_id']]

    expect(policy.people).to eq([person_1, person_2])

    first_read = policy.people.object_id
    second_read = policy.people.object_id
    expect(first_read).to eq(second_read)
  end

  it "caches tagged groups" do
    stub_content_calls_from_publishing_api

    policy = FactoryGirl.create(:policy,
      working_group_content_ids: [
        working_group_1['content_id'],
        working_group_2['content_id']
      ])

    expect(policy.working_groups).to eq([working_group_1, working_group_2])

    policy.working_group_content_ids = [working_group_2['content_id'], working_group_1['content_id']]

    expect(policy.working_groups).to eq([working_group_1, working_group_2])

    first_read = policy.working_groups.object_id
    second_read = policy.working_groups.object_id
    expect(first_read).to eq(second_read)
  end

  it "ignores non-existent tagged organisations" do
    stub_content_calls_from_publishing_api

    policy = Policy.new(organisation_content_ids: [SecureRandom.uuid])
    expect(policy.organisations).to eq([])
  end

  it "ignores non-existent tagged people" do
    stub_content_calls_from_publishing_api

    policy = Policy.new(people_content_ids: [SecureRandom.uuid])
    expect(policy.people).to eq([])
  end

  it "ignores non-existent tagged working groups" do
    stub_content_calls_from_publishing_api

    policy = Policy.new(working_group_content_ids: [SecureRandom.uuid])
    expect(policy.working_groups).to eq([])
  end

  it "gets a list of applicable nations" do
    policy = FactoryGirl.create(
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
    policy = FactoryGirl.build(
      :policy,
      northern_ireland: false,
      northern_ireland_policy_url: "bad-url",
    )

    expect(policy).not_to be_valid
    expect(policy.errors.messages).to eq({:northern_ireland=>["must have a valid alternative policy URL"]})
  end

  it "allows valid alternative policy URLs" do
    policy = FactoryGirl.build(
      :policy,
      northern_ireland: false,
      northern_ireland_policy_url: "http://example.ni",
    )

    expect(policy).to be_valid
  end

  it "allows specifying no alternative policy URL" do
    policy = FactoryGirl.build(
      :policy,
      northern_ireland: false,
    )

    expect(policy).to be_valid
  end
end
