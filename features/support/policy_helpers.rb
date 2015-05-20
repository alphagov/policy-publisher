require 'gds_api/test_helpers/publishing_api'

module PolicyHelpers
  include GdsApi::TestHelpers::PublishingApi

  def check_nation_applicability(policy, nation)
    nation = nation.downcase.gsub(' ', '_')
    policy.send(nation) == true

    policy.inapplicable_nations.each do |n|
      policy.send("#{nation}_policy_url") == "http://www.#{nation}policyurl.com"
    end
  end

  def create_policy(name:, description: "A policy description", inapplicable_nations: [], alt_policy_urls: {})
    visit policies_path
    click_on "New policy area"

    fill_in "Name", with: name
    fill_in "Description", with: description

    inapplicable_nations.each do |nation|
      uncheck(nation)
      fill_in("#{nation} policy url", with: alt_policy_urls[nation])
    end

    click_on "Save"
  end

  def create_policy_programme(name:, description: "A policy description", inapplicable_nations: [], alt_policy_urls: {}, parent_policies: [])
    visit policies_path
    click_on "New policy programme"

    fill_in "Name", with: name
    fill_in "Description", with: description

    parent_policies.each do |policy_name|
      select policy_name, from: "Part of"
    end

    inapplicable_nations.each do |nation|
      uncheck(nation)
      fill_in("#{nation} policy url", with: alt_policy_urls[nation])
    end

    click_on "Save"
  end

  def edit_policy(name:, attributes:)
    visit policies_path
    click_on name

    attributes.each do |attribute, value|
      fill_in attribute.to_s.humanize, with: value
    end

    click_on "Save"
  end

  def check_for_policy(name:)
    visit policies_path
    expect(page).to have_content(name)
  end

  def associate_policy_with_organisations(policy:, organisation_names:)
    visit_policy(policy)
    selectize "Organisations", with: organisation_names
    click_on "Save"
  end

  def associate_policy_with_people(policy:, people_names:)
    visit_policy(policy)
    selectize "People", with: people_names
    click_on "Save"
  end

  def associate_policy_with_organisation(policy:, organisation_name:)
    visit_policy(policy)
    select organisation_name, from: "Organisations"
    click_on "Save"
  end

  def associate_policy_with_person(policy:, person_name:)
    visit_policy(policy)
    select person_name, from: "People"
    click_on "Save"
  end

private

  def visit_policy(policy)
    visit policies_path
    click_on policy.name
  end
end

World(PolicyHelpers)
