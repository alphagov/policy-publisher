FactoryGirl.define do
  factory :user do
    permissions { ["signin"] }
  end

  factory :policy_area do
    sequence(:name) {|n| "Policy area #{n}" }
    description "Policy area description"
  end

  factory :programme do
    sequence(:name) {|n| "Programme #{n}" }
    description "Policy programme description"
  end
end
