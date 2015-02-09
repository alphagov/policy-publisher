module PolicyHelpers
  def create_policy(name:, description: "A policy description")
    visit policies_path
    click_on "Create a policy"

    fill_in "Name", with: name
    fill_in "Description", with: description

    click_on "Save this policy"
  end

  def check_for_policy(name:)
    visit policies_path
    expect(page).to have_content(name)
  end
end

World(PolicyHelpers)
