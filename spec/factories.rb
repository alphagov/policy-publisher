FactoryGirl.define do
  factory :user do
    permissions { ["signin"] }
  end

  factory :policy do
    sequence(:name) {|n| "Policy #{n}" }
    description "Policy description"
  end

  factory :sub_policy, parent: :policy do
    parent_policies { [FactoryGirl.create(:policy)] }
  end
end
