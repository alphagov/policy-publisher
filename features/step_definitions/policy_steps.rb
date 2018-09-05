Given(/^a (?:published )?policy exists called "(.*?)"$/) do |policy_name|
  stub_any_publishing_api_write
  @policy = FactoryBot.create(:policy, name: policy_name)
  stub_publishing_api_links(@policy.content_id)
end

Given(/^it is associated with two organisations, two people and two working groups$/) do
  stub_publishing_api_links(
    @policy.content_id,
    organisations: [@organisation_1, @organisation_2].map { |org| org["content_id"] },
    lead_organisations: [@organisation_1["content_id"]],
    people: [@person_1, @person_2].map { |person| person["content_id"] },
    working_groups: [@working_group_1, @working_group_2].map { |working_group| working_group["content_id"] }
  )

  items = [organisation_1, organisation_2, person_1, person_2, working_group_1, working_group_2]
  items.each do |item|
    publishing_api_has_item(item)
  end
end

When(/^I change the title of policy "(.*?)" to "(.*?)"$/) do |old_name, new_name|
  edit_policy(name: old_name, attributes: {
    name: new_name
  })
end

When(/^I click on "New policy"$/) do
  click_on "New policy"
end

When(/^I click on "New sub-policy"$/) do
  click_on "New sub-policy"
end

When(/^I create a policy called "([^"]+?)"$/) do |policy_name|
  stub_any_publishing_api_write
  create_policy(name: policy_name)
end

When(/^I create a sub-policy called "(.*?)" that is part of a policy called "(.*?)"$/) do |policy_name, part_of_policy_name|
  stub_any_publishing_api_write

  create_sub_policy(name: policy_name, parent_policies: [part_of_policy_name])
end

# NB: if the publishing-api has not been stubbed in another step,
# these steps will act like the policy is not linked to anything before we edit it.
When(/^I associate the policy with an organisation$/) do
  associate_policy_with_organisation(policy: @policy, organisation_name: 'Organisation 1')
end

When(/^I associate the policy with a person$/) do
  associate_policy_with_person(policy: @policy, person_name: 'A Person')
end

When(/^I associate the policy with a working group$/) do
  associate_policy_with_working_group(policy: @policy, working_group_name: 'A working group')
end

When(/^I set the tagged organisations to "(.*?)" and "(.*?)"$/) do |org_name_1, org_name_2|
  associate_policy_with_organisations(policy: @policy, organisation_names: [org_name_1, org_name_2])
end

When(/^I set the tagged people to "(.*?)" and "(.*?)"$/) do |person_name_1, person_name_2|
  associate_policy_with_people(policy: @policy, people_names: [person_name_1, person_name_2])
end

When(/^I visit the main browse page$/) do
  visit policies_path
end

Then(/^there should be a policy called "([^"]+?)"$/) do |policy_name|
  check_for_policy(name: policy_name)
end

Then(/^there should be a policy called "(.*?)" that is part of a policy called "(.*?)"$/) do |policy_name, part_of_policy_name|
  policy = Policy.find_by!(name: policy_name)
  parent_policy = Policy.find_by!(name: part_of_policy_name)

  expect([parent_policy]).to eq(policy.parent_policies)
end

Then(/^a policy called "(.*?)" is published to publishing API$/) do |policy_name|
  policy = Policy.find_by(name: policy_name)
  assert_publishing_api_put_content(
    policy.content_id,
    request_json_includes(
      "document_type" => "policy",
      "schema_name" => "policy",
      "rendering_app" => "finder-frontend",
      "publishing_app" => "policy-publisher",
    ),
  )
end

Then(/^a policy called "(.*?)" is republished to publishing API$/) do |policy_name|
  policy = Policy.find_by(name: policy_name)
  assert_publishing_api_put_content(
    policy.content_id,
    request_json_includes(
      "rendering_app" => "finder-frontend",
      "publishing_app" => "policy-publisher",
    ),
  )

  assert_publishing_api_publish(
    policy.content_id,
          "update_type" => "minor",
  )
end

Then(/^an email alert signup page for a policy called "(.*?)" is published to publishing API$/) do |policy_name|
  policy = Policy.find_by(name: policy_name)
  assert_publishing_api_put_content(
    policy.email_alert_signup_content_id,
    request_json_includes(
      "document_type" => "email_alert_signup",
      "schema_name" => "email_alert_signup",
      "rendering_app" => "email-alert-frontend",
      "publishing_app" => "policy-publisher",
    ),
  )
end

Then(/^the policy should be linked to the organisation when published to publishing API$/) do
  assert_publishing_api_put_content(
    @policy.content_id,
    request_json_includes(
      "document_type" => "policy",
      "schema_name" => "policy",
      "rendering_app" => "finder-frontend",
      "publishing_app" => "policy-publisher",
      "locale" => "en",
    )
  )

  assert_publishing_api_patch_links(
    @policy.content_id,
          "links" => {
        "organisations" => [organisation_1["content_id"]],
        "lead_organisations" => [organisation_1["content_id"]],
        "people" => [],
        "working_groups" => [],
        "related" => [],
        "email_alert_signup" => [@policy.email_alert_signup_content_id]
      }
  )
end

Then(/^the policy should be linked to the person when published to publishing API$/) do
  assert_publishing_api_put_content(
    @policy.content_id,
    request_json_includes(
      "document_type" => "policy",
      "schema_name" => "policy",
      "rendering_app" => "finder-frontend",
      "publishing_app" => "policy-publisher",
      "locale" => "en",
    )
  )

  assert_publishing_api_patch_links(
    @policy.content_id,
          "links" => {
        "organisations" => [],
        "lead_organisations" => [],
        "people" => [person_1["content_id"]],
        "working_groups" => [],
        "related" => [],
        "email_alert_signup" => [@policy.email_alert_signup_content_id]
      }
  )
end

Then(/^the policy should be linked to the working group when published to publishing API$/) do
  assert_publishing_api_put_content(
    @policy.content_id,
    request_json_includes(
      "document_type" => "policy",
      "schema_name" => "policy",
      "rendering_app" => "finder-frontend",
      "publishing_app" => "policy-publisher",
      "locale" => "en",
    )
  )

  assert_publishing_api_patch_links(
    @policy.content_id,
          "links" => {
        "organisations" => [],
        "lead_organisations" => [],
        "people" => [],
        "working_groups" => [working_group_1["content_id"]],
        "related" => [],
        "email_alert_signup" => [@policy.email_alert_signup_content_id]
      }
  )
end

# The links we put to the publisher-api should match the links we got
Then(/^the policy links should remain unchanged$/) do
  assert_publishing_api_put_content(
    @policy.content_id,
    request_json_includes(
      "document_type" => "policy",
      "schema_name" => "policy",
      "rendering_app" => "finder-frontend",
      "publishing_app" => "policy-publisher",
      "locale" => "en",
    )
  )

  assert_publishing_api_patch_links(
    @policy.content_id,
          "links" => {
        "organisations" => [organisation_1["content_id"], organisation_2["content_id"]],
        "lead_organisations" => [organisation_1["content_id"]],
        "people" => [person_1["content_id"], person_2["content_id"]],
        "working_groups" => [working_group_1["content_id"], working_group_2["content_id"]],
        "related" => [],
        "email_alert_signup" => [@policy.email_alert_signup_content_id]
      }
  )
end

When(/^I create a policy called "([^"]+?)" that only applies to "([^"]+?)"$/) do |policy_name, nation|
  stub_any_publishing_api_write
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
end

Then(/^there should be a policy called "([^"]+?)" which only applies to "([^"]+?)"$/) do |policy_name, nation|
  policy = Policy.find_by_name(policy_name)
  check_nation_applicability(policy, nation)
end
