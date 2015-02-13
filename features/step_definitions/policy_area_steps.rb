Given(/^a published policy area exists called "(.*?)"$/) do |policy_area_name|
  stub_publishing_api
  FactoryGirl.create(:policy_area, name: policy_area_name)
end

When(/^I change the title of policy area "(.*?)" to "(.*?)"$/) do |old_name, new_name|
  edit_policy_area(name: old_name, attributes: {
    name: new_name
  })
end

When(/^I create a policy area called "(.*?)"$/) do |policy_area_name|
  stub_publishing_api
  create_policy_area(name: policy_area_name)
end

Then(/^there should be a policy area called "(.*?)"$/) do |policy_area_name|
  check_for_policy_area(name: policy_area_name)
end

Then(/^a policy area called "(.*?)" is published "(.*?)" times$/) do |policy_area_name, times|
  check_policy_area_is_published_to_publishing_api("/government/policies/#{policy_area_name.to_s.parameterize}", times.to_i)
end
