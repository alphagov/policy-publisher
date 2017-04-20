require 'rails_helper'

RSpec.describe PolicyForm do
  include PublishingApiContentHelpers

  before do
    stub_content_calls_from_publishing_api
    stub_any_publishing_api_write
    stub_any_publishing_api_publish
    stub_post_to_search
  end

  let(:policy_attributes) do
    {
      name: 'A Policy',
      description: 'A Policy description',
      lead_organisation_content_ids: [],
      supporting_organisation_content_ids: [],
    }
  end

  def set_organisation_attributes(lead = [], supporting = [])
    policy_attributes.merge!(
      lead_organisation_content_ids: lead,
      supporting_organisation_content_ids: supporting
)
  end

  context 'validations' do
    context 'when organisations' do
      it 'should not have lead organisations that are also supporting organisations' do
        set_organisation_attributes([1], [1, 2, 3])

        policy_form = PolicyForm.new(policy_attributes)

        expect(policy_form.valid?).to be_falsey
        expect(policy_form.errors.full_messages.first).to match(/Supporting organisation/)
      end

      it 'valid to have different lead and supporting organisations' do
        set_organisation_attributes([1], [2, 3])

        policy_form = PolicyForm.new(policy_attributes)

        expect(policy_form.valid?).to be_truthy
      end

      it 'valid to have lead organisations without supporting organisations' do
        set_organisation_attributes([1])

        policy_form = PolicyForm.new(policy_attributes)
        policy_form.save

        expect(policy_form.valid?).to be_truthy
      end

      it 'not valid to have supporting organisations without lead organisations' do
        set_organisation_attributes([], [1])

        policy_form = PolicyForm.new(policy_attributes)

        expect(policy_form.valid?).to be_falsey
        expect(policy_form.errors.full_messages.first).to match(/Lead organisation/)
      end

      it 'valid to have no organisations' do
        policy_form = PolicyForm.new(policy_attributes)

        expect(policy_form.valid?).to be_truthy
      end
    end
  end

  describe '.from_existing' do
    let(:policy) { FactoryGirl.create(:policy, name: "Climate change") }

    before do
      stub_has_links(policy)
    end

    it 'loads active record attributes from the policy model' do
      policy_form = PolicyForm.from_existing(policy)

      expect(policy_form.name).to eql "Climate change"
    end

    it 'loads organisation ids from the policy model' do
      policy.organisation_content_ids = [1, 2, 3]
      policy.lead_organisation_content_ids = [1]
      policy_form = PolicyForm.from_existing(policy)

      expect(policy_form.lead_organisation_content_ids).to eql [1]
      expect(policy_form.supporting_organisation_content_ids).to eql [2, 3]
    end

    it 'loads people ids from the policy model' do
      policy.people_content_ids = [1, 2, 3]
      policy_form = PolicyForm.from_existing(policy)

      expect(policy_form.people_content_ids).to eql [1, 2, 3]
    end
  end

  describe '#save' do
    it 'passes through people content ids to the model' do
      policy_form = PolicyForm.new(policy_attributes.merge(people_content_ids: [1, 2, 3]))
      policy_form.save

      expect(policy_form.policy.people_content_ids).to eql [1, 2, 3]
    end

    it 'passes through name to the model' do
      policy_name = "Free ice cream"
      policy_form = PolicyForm.new(policy_attributes.merge(name: policy_name))
      policy_form.save

      expect(policy_form.policy.name).to eql policy_name
    end

    it 'combines lead and supporting organisations into organisations on the policy model' do
      set_organisation_attributes([1, 2], [3, 4])

      policy_form = PolicyForm.new(policy_attributes)
      policy_form.save
      policy = policy_form.policy

      expect(policy.organisation_content_ids).to eql [1, 2, 3, 4]
    end
  end
end
