require "rails_helper"
require 'gds_api/test_helpers/publishing_api'
require 'gds_api/test_helpers/rummager'

RSpec.describe Publisher do
  include GdsApi::TestHelpers::PublishingApi
  include GdsApi::TestHelpers::Rummager

  before do
    stub_default_publishing_api_put
    stub_any_rummager_post
  end

  context "when publishing a policy" do
    let!(:policy) { FactoryGirl.create(:policy) }

    before do
      WebMock::RequestRegistry.instance.reset!
      Publisher.new(policy).publish!
    end

    it "publishes the policy to the Publishing API" do
      assert_publishing_api_put_item(
        policy.base_path,
        ContentItemPresenter.new(policy).exportable_attributes.as_json
      )
    end

    it "adds the policy to the rummager search index" do
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
  end


  context "when publishing a policy programme" do
    let!(:policy_programme) { FactoryGirl.create(:policy_programme) }

    before do
      WebMock::RequestRegistry.instance.reset!
      Publisher.new(policy_programme).publish!
    end

    it "publishes the policy programme to the Publishing API" do
      assert_publishing_api_put_item(
        policy_programme.base_path,
        ContentItemPresenter.new(policy_programme).exportable_attributes.as_json
      )
    end

    it "adds the policy programme to the rummager search index" do
      expected_json = JSON.parse({
        title: policy_programme.name,
        description: policy_programme.description,
        link: policy_programme.base_path,
        indexable_content: "",
        organisations: [],
        last_update: policy_programme.updated_at,
        _type: "policy",
        _id: policy_programme.base_path,
      }.to_json)

      assert_rummager_posted_item(expected_json)
    end

    it "republishes the parent policies" do
      parent_policy = policy_programme.parent_policies.first
      assert_publishing_api_put_item(
        parent_policy.base_path,
        ContentItemPresenter.new(parent_policy, "minor").exportable_attributes.as_json
      )
    end
  end
end
