FactoryGirl.define do
  factory :user do
    permissions { ["signin"] }
  end

  factory :policy do
    sequence(:name) {|n| "Policy #{n}" }
    description "Policy description"
  end

  factory :policy_programme, parent: :policy do
    parent_policies { [FactoryGirl.create(:policy)] }
  end
end
