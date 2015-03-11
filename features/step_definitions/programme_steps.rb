Given(/^a programme exists called "(.*?)"$/) do |programme_name|
  stub_publishing_api
  stub_rummager
  FactoryGirl.create(:programme, name: programme_name)
  reset_remote_requests
end

When(/^I change the title of programme "(.*?)" to "(.*?)"$/) do |old_name, new_name|
  edit_programme(name: old_name, attributes: {
    name: new_name
  })
end

When(/^I create a programme called "(.*?)"$/) do |programme_name|
  stub_publishing_api
  stub_rummager
  create_programme(name: programme_name)
end

Then(/^there should be a programme called "(.*?)"$/) do |programme_name|
  check_for_programme(name: programme_name)
end

When(/^I associate the programme "(.*?)" with the policy areas "(.*?)" and "(.*?)"$/) do |programme_name, pa_1_name, pa_2_name|
  associate_programme_with_policy_areas(
    programme_name: programme_name,
    policy_area_names: [pa_1_name, pa_2_name]
  )
end

Then(/^the programme "(.*?)" should be associated with the policy areas "(.*?)" and "(.*?)"$/) do |programme_name, pa_1_name, pa_2_name|
  check_for_programme_association(
    programme_name: programme_name,
    policy_area_names: [pa_1_name, pa_2_name]
  )
end

Then(/^a programme called "(.*?)" is published to publishing API$/) do |programme_name|
  assert_content_item_is_published_to_publishing_api("/government/policies/#{programme_name.to_s.parameterize}")
end

Then(/^a programme called "(.*?)" is indexed for search$/) do |programme_name|
  programme = Programme.find_by_name(programme_name)
  assert_policy_published_to_rummager(programme)
end
