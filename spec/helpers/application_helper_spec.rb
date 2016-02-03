require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#policy_type' do
    context 'when is not a sub policy' do
      it 'returns "policy"' do
        policy = create :policy

        expect(helper.policy_type(policy)).to eq('policy')
      end
    end

    context 'when is a sub policy' do
      it 'returns "sub-policy"' do
        policy = create :sub_policy

        expect(helper.policy_type(policy)).to eq('sub-policy')
      end
    end
  end
end
