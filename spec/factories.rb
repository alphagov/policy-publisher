FactoryGirl.define do
  factory :user do
    permissions { ["signin"] }
  end

  factory :policy_area do
    sequence(:name) {|n| "Policy area #{n}" }
  end
end
