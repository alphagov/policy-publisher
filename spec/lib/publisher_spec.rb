require "rails_helper"
require 'gds_api/test_helpers/publishing_api'
require 'gds_api/test_helpers/rummager'

RSpec.describe Publisher do
  include GdsApi::TestHelpers::PublishingApi
  include GdsApi::TestHelpers::Rummager

  let(:indexer) { double(:indexer) }

  before do
    stub_default_publishing_api_put
    allow(SearchIndexer).to receive(:new).with(policy).and_return(indexer)
    allow(indexer).to receive(:run!)
  end

  context "when publishing a policy" do
    let(:policy) { FactoryGirl.create(:policy) }

    before do
      Publisher.new(policy).publish!
    end

    it "publishes the policy to the Publishing API" do
      assert_publishing_api_put_item(
        policy.base_path,
        ContentItemPresenter.new(policy).exportable_attributes.as_json
      )
    end

    it "adds the policy to the rummager search index" do
      expect(indexer).to have_received(:run!)
    end
  end


  context "when publishing a sub-policy" do
    let!(:policy) { FactoryGirl.create(:policy_programme) }

    before do
      Publisher.new(policy).publish!
    end

    it "publishes the sub-policy to the Publishing API" do
      assert_publishing_api_put_item(
        policy.base_path,
        ContentItemPresenter.new(policy).exportable_attributes.as_json
      )
    end

    it "adds the sub-policy to the rummager search index" do
      expect(indexer).to have_received(:run!)
    end

    it "republishes the parent policies" do
      parent_policy = policy.parent_policies.first
      assert_publishing_api_put_item(
        parent_policy.base_path,
        ContentItemPresenter.new(parent_policy, "minor").exportable_attributes.as_json
      )
    end
  end
end
