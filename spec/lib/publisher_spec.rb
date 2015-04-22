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


  context "when publishing a policy programme" do
    let!(:policy) { FactoryGirl.create(:policy_programme) }

    before do
      Publisher.new(policy).publish!
    end

    it "publishes the policy programme to the Publishing API" do
      assert_publishing_api_put_item(
        policy.base_path,
        ContentItemPresenter.new(policy).exportable_attributes.as_json
      )
    end

    it "adds the policy programme to the rummager search index" do
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


  context "when future-policies feature flag is off" do
    let(:policy) { FactoryGirl.create(:policy) }
    let!(:rummager_request) { stub_any_rummager_post }

    around do |example|
      flag_value = ENV.delete('ENABLE_FUTURE_POLICIES')
      example.run
      ENV['ENABLE_FUTURE_POLICIES'] = flag_value
    end

    before do
      Publisher.new(policy).publish!
    end

    it "pushes a placeholder content item to the Publishing API" do
      payload = PlaceholderContentItemPresenter.new(policy).exportable_attributes.as_json
      assert_publishing_api_put_item(policy.base_path, payload)
    end

    it "does not add the policy to the rummager search index" do
      assert_not_requested rummager_request
    end
  end
end
