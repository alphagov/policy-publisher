module Selectize
  def selectize(key, with:)
    # clear any existing selections
    page.execute_script("$('.selectize-input a.remove').click()");

    select_field = page.find_field(key, visible: false)
    selectize_control = "select##{select_field[:id]} + .selectize-control"

    Array(with).each do |value|
      # Fill in the value into the input field
      page.execute_script("$('#{selectize_control} .selectize-input input').val('#{value}');")
      # Simulate selecting the first option
      page.execute_script("$('#{selectize_control} .selectize-input input').keyup();")
      page.execute_script("$('#{selectize_control} div.option').first().mousedown();")
    end
  end
end

World(Selectize)
