When(/^I create a policy called "(.*?)"$/) do |policy_name|
  create_policy(name: policy_name)
end

Then(/^there should be a policy called "(.*?)"$/) do |policy_name|
  check_for_policy(name: policy_name)
end
