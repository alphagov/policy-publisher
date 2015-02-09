FactoryGirl.define do
  factory :user do
    permissions { ["signin"] }
  end

  factory :policy do
    sequence(:name) {|n| "Policy #{n}" }
  end
end
