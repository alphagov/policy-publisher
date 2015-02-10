Given(/^a policy exists called "(.*?)"$/) do |policy_name|
  FactoryGirl.create(:policy, name: policy_name)
end

When(/^I change the title of policy "(.*?)" to "(.*?)"$/) do |old_name, new_name|
  edit_policy(name: old_name, attributes: {
    name: new_name
  })
end

When(/^I create a policy called "(.*?)"$/) do |policy_name|
  create_policy(name: policy_name)
end

Then(/^there should be a policy called "(.*?)"$/) do |policy_name|
  check_for_policy(name: policy_name)
end
