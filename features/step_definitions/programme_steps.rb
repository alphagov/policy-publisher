Given(/^a programme exists called "(.*?)"$/) do |programme_name|
  stub_publishing_api
  FactoryGirl.create(:programme, name: programme_name)
end

When(/^I change the title of programme "(.*?)" to "(.*?)"$/) do |old_name, new_name|
  edit_programme(name: old_name, attributes: {
    name: new_name
  })
end

When(/^I create a programme called "(.*?)"$/) do |programme_name|
  stub_publishing_api
  create_programme(name: programme_name)
end

Then(/^there should be a programme called "(.*?)"$/) do |programme_name|
  check_for_programme(name: programme_name)
end

Then(/^a programme called "(.*?)" is published "(.*?)" times$/) do |policy_area_name, times|
  check_content_item_is_published_to_publishing_api("/government/policies/#{policy_area_name.to_s.parameterize}", times.to_i)
end