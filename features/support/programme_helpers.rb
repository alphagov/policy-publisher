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
end

World(ProgrammeHelpers)
