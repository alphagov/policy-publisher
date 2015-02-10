module PolicyHelpers
  def create_policy(name:, description: "A policy description")
    visit policies_path
    click_on "Create a policy"

    fill_in "Name", with: name
    fill_in "Description", with: description

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
end

World(PolicyHelpers)
