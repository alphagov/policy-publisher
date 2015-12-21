Given(/^a (?:published )?policy exists called "(.*?)"$/) do |policy_name|
  stub_any_publishing_api_call
  stub_rummager
  @policy = FactoryGirl.create(:policy, name: policy_name)
end

Given(/^the policy is associated with the organisations "(.*?)" and "(.*?)"$/) do |org_name_1, org_name_2|
  associate_policy_with_organisations(policy: @policy, organisation_names: [org_name_1, org_name_2])
end

Given(/^the policy is associated with the people "(.*?)" and "(.*?)"$/) do |person_name_1, person_name_2|
  associate_policy_with_people(policy: @policy, people_names: [person_name_1, person_name_2])
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
  stub_any_publishing_api_call
  stub_rummager
  create_policy(name: policy_name)
end

When(/^I create a sub-policy called "(.*?)" that is part of a policy called "(.*?)"$/) do |policy_name, part_of_policy_name|
  stub_any_publishing_api_call
  stub_rummager

  create_sub_policy(name: policy_name, parent_policies: [part_of_policy_name])
end

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
    {
      "format" => "policy",
      "rendering_app" => "finder-frontend",
      "publishing_app" => "policy-publisher",
    },
  )
end

Then(/^a policy called "(.*?)" is republished to publishing API$/) do |policy_name|
  policy = Policy.find_by(name: policy_name)
  assert_publishing_api_put_content(
    policy.content_id,
    {
      "rendering_app" => "finder-frontend",
      "publishing_app" => "policy-publisher",
    },
  )

  assert_publishing_api_publish(
    policy.content_id,
    {
      "update_type" => "minor",
    },
  )
end

Then(/^an email alert signup page for a policy called "(.*?)" is published to publishing API$/) do |policy_name|
  policy = Policy.find_by(name: policy_name)
  assert_publishing_api_put_content(
    policy.email_alert_signup_content_id,
    {
      "format" => "email_alert_signup",
      "rendering_app" => "email-alert-frontend",
      "publishing_app" => "policy-publisher",
    },
  )
end

Then(/^a policy called "(.*?)" is indexed for search$/) do |policy_name|
  policy = Policy.find_by_name(policy_name)
  assert_policy_published_to_rummager(policy)
end

Then(/^the policy should be linked to the organisation when published to publishing API$/) do
  assert_publishing_api_put_content(
    @policy.content_id,
    {
      "format" => "policy",
      "rendering_app" => "finder-frontend",
      "publishing_app" => "policy-publisher",
      "locale" => "en",
    }
  )

  assert_publishing_api_put_links(
    @policy.content_id,
    {
      "links" => {
        "organisations" => [organisation_1["content_id"]],
        "people" => [],
        "working_groups" => [],
        "related" => [],
        "email_alert_signup" => [@policy.email_alert_signup_content_id],
        "policy_areas" => [],
      },
    }
  )
end

Then(/^the policy should be linked to the person when published to publishing API$/) do
  assert_publishing_api_put_content(
    @policy.content_id,
    {
      "format" => "policy",
      "rendering_app" => "finder-frontend",
      "publishing_app" => "policy-publisher",
      "locale" => "en",
    }
  )

  assert_publishing_api_put_links(
    @policy.content_id,
    {
      "links" => {
        "organisations" => [],
        "people" => [person_1["content_id"]],
        "working_groups" => [],
        "related" => [],
        "email_alert_signup" => [@policy.email_alert_signup_content_id],
        "policy_areas" => [],
      }
    }
  )
end

Then(/^the policy should be linked to the working group when published to publishing API$/) do
  assert_publishing_api_put_content(
    @policy.content_id,
    {
      "format" => "policy",
      "rendering_app" => "finder-frontend",
      "publishing_app" => "policy-publisher",
      "locale" => "en",
    }
  )

  assert_publishing_api_put_links(
    @policy.content_id,
    {
      "links" => {
        "organisations" => [],
        "people" => [],
        "working_groups" => [working_group_1["content_id"]],
        "related" => [],
        "email_alert_signup" => [@policy.email_alert_signup_content_id],
        "policy_areas" => [],
      }
    }
  )
end

Then(/^the policy organisations should appear in the order "(.*?)" and "(.*?)"$/) do |org_name_1, org_name_2|
  first_org = PolicyPublisher.services(:content_register).organisations.find { |organisation| organisation["title"] == org_name_1 }
  second_org = PolicyPublisher.services(:content_register).organisations.find { |organisation| organisation["title"] == org_name_2 }

  expect(@policy.reload.organisations).to eq([first_org, second_org])
end

Then(/^the policy people should appear in the order "(.*?)" and "(.*?)"$/) do |person_name_1, person_name_2|
  first_person = PolicyPublisher.services(:content_register).people.find { |person| person["title"] == person_name_1 }
  second_person = PolicyPublisher.services(:content_register).people.find { |person| person["title"] == person_name_2 }

  expect(@policy.reload.people).to eq([first_person, second_person])
end

When(/^I create a policy called "([^"]+?)" that only applies to "([^"]+?)"$/) do |policy_name, nation|
  stub_any_publishing_api_call
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
end

Then(/^there should be a policy called "([^"]+?)" which only applies to "([^"]+?)"$/) do |policy_name, nation|
  policy = Policy.find_by_name(policy_name)
  check_nation_applicability(policy, nation)
end
