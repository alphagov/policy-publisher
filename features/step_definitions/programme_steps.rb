Given(/^a programme exists called "(.*?)"$/) do |programme_name|
  FactoryGirl.create(:programme, name: programme_name)
end

When(/^I change the title of programme "(.*?)" to "(.*?)"$/) do |old_name, new_name|
  edit_programme(name: old_name, attributes: {
    name: new_name
  })
end

When(/^I create a programme called "(.*?)"$/) do |programme_name|
  create_programme(name: programme_name)
end

Then(/^there should be a programme called "(.*?)"$/) do |programme_name|
  check_for_programme(name: programme_name)
end
