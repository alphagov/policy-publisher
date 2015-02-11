Given(/^a policy area exists called "(.*?)"$/) do |policy_area_name|
  FactoryGirl.create(:policy_area, name: policy_area_name)
end

When(/^I change the title of policy area "(.*?)" to "(.*?)"$/) do |old_name, new_name|
  edit_policy_area(name: old_name, attributes: {
    name: new_name
  })
end

When(/^I create a policy area called "(.*?)"$/) do |policy_area_name|
  create_policy_area(name: policy_area_name)
end

Then(/^there should be a policy area called "(.*?)"$/) do |policy_area_name|
  check_for_policy_area(name: policy_area_name)
end
