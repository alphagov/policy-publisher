require 'gds_api/test_helpers/publishing_api'

module PolicyHelpers
  include GdsApi::TestHelpers::PublishingApi

  def create_policy_area(name:, description: "A policy_area description")
    visit policy_areas_path
    click_on "Create a policy area"

    fill_in "Name", with: name
    fill_in "Description", with: description

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

  def check_policy_area_is_published_to_publishing_api(base_path, times)
    assert_publishing_api_put_item(
      base_path,
      {
        "base_path" => base_path,
        "format" => "policy_area",
        "rendering_app" => "finder-frontend",
        "publishing_app" => "policy-publisher",
      },
      times,
    )
  end
end

World(PolicyHelpers)
