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
    click_on "Create a policy"

    fill_in "Name", with: name
    fill_in "Description", with: description

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

  def associate_policy_with_organisation(policy:, organisation_name:)
    visit policies_path
    click_on policy.name

    select organisation_name, from: "Organisations"
    click_on "Save"
  end

  def associate_policy_with_person(policy:, person_name:)
    visit policies_path
    click_on policy.name

    select person_name, from: "People"
    click_on "Save"
  end
end

World(PolicyHelpers)
