Given(/^a (?:published )?policy exists called "(.*?)"$/) do |policy_name|
  stub_publishing_api
  stub_rummager
  @policy = FactoryGirl.create(:policy, name: policy_name)
  reset_remote_requests
end

When(/^I change the title of policy "(.*?)" to "(.*?)"$/) do |old_name, new_name|
  edit_policy(name: old_name, attributes: {
    name: new_name
  })
end

When(/^I create a policy called "([^"]+?)"$/) do |policy_name|
  stub_publishing_api
  stub_rummager
  create_policy(name: policy_name)
end

When(/^I associate the policy with an organisation$/) do
  associate_policy_with_organisation(policy: @policy, organisation_name: 'Organisation 1')
end

When(/^I associate the policy with a person$/) do
  associate_policy_with_person(policy: @policy, person_name: 'A Person')
end

Then(/^there should be a policy called "([^"]+?)"$/) do |policy_name|
  check_for_policy(name: policy_name)
end

Then(/^a policy called "(.*?)" is published to publishing API$/) do |policy_name|
  assert_content_item_is_published_to_publishing_api("/government/policies/#{policy_name.to_s.parameterize}")
end

Then(/^a policy called "(.*?)" is indexed for search$/) do |policy_name|
  policy = Policy.find_by_name(policy_name)
  assert_policy_published_to_rummager(policy)
end

Then(/^the policy should be linked to the organisation when published to publishing API$/) do
  assert_publishing_api_put_item(
    @policy.base_path,
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

Then(/^the policy should be linked to the person when published to publishing API$/) do
  assert_publishing_api_put_item(
    @policy.base_path,
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

When(/^I create a policy called "([^"]+?)" that only applies to "([^"]+?)"$/) do |policy_name, nation|
  stub_publishing_api
  stub_rummager
  possible_nations = ["England", "Northern Ireland", "Scotland", "Wales"]
  inapplicable_nations = possible_nations - [nation]
  alt_policy_urls = {}

  inapplicable_nations.each do |n|
    alt_policy_urls[n] = "http://www.#{n}policyurl.com"
  end

  create_policy(
    name: policy_name,
    inapplicable_nations: inapplicable_nations,
    alt_policy_urls: alt_policy_urls,
  )

  reset_remote_requests
end

Then(/^there should be a policy called "([^"]+?)" which only applies to "([^"]+?)"$/) do |policy_name, nation|
  policy = Policy.find_by_name(policy_name)
  check_nation_applicability(policy, nation)
end