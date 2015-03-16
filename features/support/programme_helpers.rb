module ProgrammeHelpers
  def create_programme(name:, description: "A programme description")
    visit programmes_path
    click_on "Create a programme"

    fill_in "Name", with: name
    fill_in "Description", with: description

    click_on "Save"
  end

  def edit_programme(name:, attributes:)
    visit programmes_path
    click_on name

    attributes.each do |attribute, value|
      fill_in attribute.to_s.humanize, with: value
    end

    click_on "Save"
  end

  def check_for_programme(name:)
    visit programmes_path
    expect(page).to have_content(name)
  end

  def associate_programme_with_policy_areas(programme_name:, policy_area_names:)
    visit programmes_path
    click_on programme_name

    policy_area_names.each do |pa_name|
      select pa_name, from: "Policy areas"
    end

    click_on "Save"
  end

  def check_for_programme_association(programme_name:, policy_area_names:)
    visit policy_areas_path

    policy_area_names.each do |pa_name|
      policy_area = PolicyArea.find_by_name(pa_name)

      within("#policy_area_#{policy_area.id}") do
        expect(page).to have_content(programme_name)
      end
    end
  end

  def associate_programme_with_organisation(programme:, organisation_name:)
    visit programmes_path
    click_on programme.name

    select organisation_name, from: "Organisations"
    click_on "Save"
  end
end

World(ProgrammeHelpers)
