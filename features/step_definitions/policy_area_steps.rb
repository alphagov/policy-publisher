Given(/^a (?:published )?policy area exists called "(.*?)"$/) do |policy_area_name|
  stub_publishing_api
  stub_rummager
  @policy_area = FactoryGirl.create(:policy_area, name: policy_area_name)
  reset_remote_requests
end

When(/^I change the title of policy area "(.*?)" to "(.*?)"$/) do |old_name, new_name|
  edit_policy_area(name: old_name, attributes: {
    name: new_name
  })
end

When(/^I create a policy area called "(.*?)"$/) do |policy_area_name|
  stub_publishing_api
  stub_rummager
  create_policy_area(name: policy_area_name)
end

When(/^I associate the policy area with an organisation$/) do
  associate_policy_area_with_organisation(policy_area: @policy_area, organisation_name: 'Organisation 1')
end

When(/^I associate the policy area with a person$/) do
  asociate_policy_area_with_person(policy_area: @policy_area, person_name: 'A Person')
end

Then(/^there should be a policy area called "(.*?)"$/) do |policy_area_name|
  check_for_policy_area(name: policy_area_name)
end

Then(/^a policy area called "(.*?)" is published to publishing API$/) do |policy_area_name|
  assert_content_item_is_published_to_publishing_api("/government/policies/#{policy_area_name.to_s.parameterize}")
end

Then(/^a policy area called "(.*?)" is indexed for search$/) do |policy_area_name|
  policy_area = PolicyArea.find_by_name(policy_area_name)
  assert_policy_published_to_rummager(policy_area)
end

Then(/^the policy area should be linked to the organisation when published to publishing API$/) do
  assert_publishing_api_put_item(
    @policy_area.base_path,
    {
      "format" => "policy",
      "rendering_app" => "finder-frontend",
      "publishing_app" => "policy-publisher",
      "locale" => "en",
      "links" => {
        "organisations" => [organisation_1["content_id"]],
        "people" => [],
        "related" => [],
      },
    }
  )
end

Then(/^the policy area should be linked to the person when published to publishing API$/) do
  assert_publishing_api_put_item(
    @policy_area.base_path,
    {
      "format" => "policy",
      "rendering_app" => "finder-frontend",
      "publishing_app" => "policy-publisher",
      "locale" => "en",
      "links" => {
        "organisations" => [],
        "people" => [person_1["content_id"]],
        "related" => [],
      },
    }
  )
end
