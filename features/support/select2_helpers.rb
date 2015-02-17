module Select2Helpers
  def select2(scope, with:)
    select2_container = first("#{scope} .select2-container")
    select2_container.first(".select2-search-choice").click

    select2_container.first("input.select2-input").set(with)
    page.execute_script(%|$("#{scope} input.select2-input:visible").keyup();|)
    find(:xpath, "//body").find(".select2-results li", text: with).click
  end
end

World(Select2Helpers)
