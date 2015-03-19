require 'gds_api/test_helpers/publishing_api'

module PolicyAreaHelpers
  include GdsApi::TestHelpers::PublishingApi

  def create_policy_area(name:, description: "A policy_area description", inapplicable_nations: [], alt_policy_urls: {})
    visit policy_areas_path
    click_on "Create a policy area"

    fill_in "Name", with: name
    fill_in "Description", with: description

    inapplicable_nations.each do |nation|
      uncheck(nation)
      fill_in("#{nation} policy url", with: alt_policy_urls[nation])
    end

    click_on "Save"
  end

  def edit_policy_area(name:, attributes:)
    visit policy_areas_path
    click_on name

    attributes.each do |attribute, value|
      fill_in attribute.to_s.humanize, with: value
    end

    click_on "Save"
  end

  def check_for_policy_area(name:)
    visit policy_areas_path
    expect(page).to have_content(name)
  end

  def associate_policy_area_with_organisation(policy_area:, organisation_name:)
    visit policy_areas_path
    click_on policy_area.name

    select organisation_name, from: "Organisations"
    click_on "Save"
  end

  def asociate_policy_area_with_person(policy_area:, person_name:)
    visit policy_areas_path
    click_on policy_area.name

    select person_name, from: "People"
    click_on "Save"
  end
end

World(PolicyAreaHelpers)
