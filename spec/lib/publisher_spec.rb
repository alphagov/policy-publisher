require "rails_helper"
require 'gds_api/test_helpers/publishing_api_v2'
require 'gds_api/test_helpers/rummager'

RSpec.describe Publisher do
  include GdsApi::TestHelpers::PublishingApiV2
  include GdsApi::TestHelpers::Rummager

  let(:indexer) { double(:indexer) }

  before do
    stub_any_publishing_api_call
    allow(SearchIndexer).to receive(:new).with(policy).and_return(indexer)
    allow(indexer).to receive(:run!)
  end

  context "when publishing a policy" do
    let(:policy) { FactoryGirl.create(:policy) }

    before do
      Publisher.new(policy).publish!
    end

    it "publishes the policy to the Publishing API" do
      assert_publishing_api_put_content(
        policy.content_id,
        ContentItemPresenter.new(policy).exportable_attributes.as_json
      )

      assert_publishing_api_publish(
        policy.content_id,
        update_type: "major"
      )

      assert_publishing_api_put_links(
        policy.content_id
      )
    end

    it "adds the policy to the rummager search index" do
      expect(indexer).to have_received(:run!)
    end
  end


  context "when publishing a sub-policy" do
    let!(:policy) { FactoryGirl.create(:sub_policy) }

    before do
      Publisher.new(policy).publish!
    end

    it "publishes the sub-policy to the Publishing API" do
      assert_publishing_api_put_content(
        policy.content_id,
        ContentItemPresenter.new(policy).exportable_attributes.as_json
      )

      assert_publishing_api_publish(
        policy.content_id,
        update_type: "major"
      )

      assert_publishing_api_put_links(
        policy.content_id
      )
    end

    it "adds the sub-policy to the rummager search index" do
      expect(indexer).to have_received(:run!)
    end

    it "republishes the parent policies" do
      parent_policy = policy.parent_policies.first
      assert_publishing_api_put_content(
        parent_policy.content_id,
        ContentItemPresenter.new(parent_policy).exportable_attributes.as_json
      )

      assert_publishing_api_publish(
        parent_policy.content_id,
        update_type: "minor"
      )

      assert_publishing_api_put_links(
        policy.content_id
      )
    end
  end
end
