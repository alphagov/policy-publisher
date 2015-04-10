Given(/^a programme exists called "(.*?)"$/) do |programme_name|
  stub_publishing_api
  stub_rummager
  @programme = FactoryGirl.create(:programme, name: programme_name)
  reset_remote_requests
end

When(/^I change the title of programme "(.*?)" to "(.*?)"$/) do |old_name, new_name|
  edit_programme(name: old_name, attributes: {
    name: new_name
  })
end

When(/^I create a programme called "([^"]+?)"$/) do |programme_name|
  stub_publishing_api
  stub_rummager
  create_programme(name: programme_name)
end

When(/^I associate the programme with an organisation$/) do
    associate_programme_with_organisation(programme: @programme, organisation_name: 'Organisation 2')
end

Then(/^there should be a programme called "([^"]+?)"$/) do |programme_name|
  check_for_programme(name: programme_name)
end

When(/^I associate the programme "(.*?)" with the policy areas "(.*?)" and "(.*?)"$/) do |programme_name, pa_1_name, pa_2_name|
  associate_programme_with_policy_areas(
    programme_name: programme_name,
    policy_area_names: [pa_1_name, pa_2_name]
  )
end

When(/^I associate the programme with a person$/) do
  asociate_programme_with_person(programme: @programme, person_name: 'Another Person')
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

Then(/^the programme should be linked to the organisation when published to publishing API$/) do
  assert_publishing_api_put_item(
    @programme.base_path,
    {
      "format" => "policy",
      "rendering_app" => "finder-frontend",
      "publishing_app" => "policy-publisher",
      "locale" => "en",
      "links" => {
        "organisations" => [organisation_2["content_id"]],
        "people" => [],
        "related" => [],
      },
    }
  )
end

Then(/^the programme should be linked to the person when published to publishing API$/) do
  assert_publishing_api_put_item(
    @programme.base_path,
    {
      "format" => "policy",
      "rendering_app" => "finder-frontend",
      "publishing_app" => "policy-publisher",
      "locale" => "en",
      "links" => {
        "organisations" => [],
        "people" => [person_2["content_id"]],
        "related" => [],
      },
    }
  )
end


When(/^I create a programme called "([^"]+?)" that only applies to "([^"]+?)"$/) do |programme_name, nation|
  stub_publishing_api
  stub_rummager
  possible_nations = ["England", "Northern Ireland", "Scotland", "Wales"]
  inapplicable_nations = possible_nations - [nation]
  alt_policy_urls = {}

  inapplicable_nations.each do |n|
    alt_policy_urls[n] = "http://www.#{n.downcase.gsub(' ', '_')}policyurl.com"
  end

  create_programme(
    name: programme_name,
    inapplicable_nations: inapplicable_nations,
    alt_policy_urls: alt_policy_urls,
  )

  reset_remote_requests
end

Then(/^there should be a programme called "([^"]+?)" which only applies to "([^"]+?)"$/) do |programme_name, nation|
  programme = Programme.find_by_name(programme_name)
  check_nation_applicability(programme, nation)
end
