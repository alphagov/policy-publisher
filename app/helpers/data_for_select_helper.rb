module DataForSelectHelper
  # Re-orders the data container such that +selected+ ones appear first.
  # and both in alphabetical order
  def prioritise_data_container(unprioritised_container, selected)
    return unprioritised_container if selected.empty?

    selected_items = []

    unselected_items = unprioritised_container.each do |item|
      selected.each do |selected_item|
        if item[1] == selected_item
          selected_items << item
          unprioritised_container.delete(item)
        end
      end
    end

    (selected_items.sort + unselected_items)
  end

  # Generates options for an organisations select field
  def organisations_data_container
    ContentItemFetcher.new.organisations
      .sort_by { |organisation| organisation['title'] }
      .map { |org| [org['title'], org['content_id']] }
  end

  # Generates options for the people select field
  def people_data_container
    ContentItemFetcher.new.people
      .sort_by { |person| person['title'] }
      .map { |person| [person['title'], person['content_id']] }
  end

  # Generates options for the working groups select field
  def working_groups_data_container
    ContentItemFetcher.new.working_groups
      .sort_by { |working_group| working_group['title'] }
      .map { |wg| [wg['title'], wg['content_id']] }
  end


  # Generates options for the policy areas select field
  def policies_areas_data_container
    Policy.areas.map { |policy| [policy.name, policy.id] }
  end
end
