FactoryGirl.define do
  factory :user do
    permissions { ["signin"] }
  end

  factory :policy do
    sequence(:name) {|n| "Policy #{n}" }
    description "Policy description"
  end

  factory :policy_area do
    sequence(:name) {|n| "Policy area #{n}" }
    description "Policy area description"
    england true
    northern_ireland true
    scotland true
    wales true
  end

  factory :programme do
    sequence(:name) {|n| "Programme #{n}" }
    description "Policy programme description"
    england true
    northern_ireland true
    scotland true
    wales true
  end
end
