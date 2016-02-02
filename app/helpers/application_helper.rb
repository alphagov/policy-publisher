module ApplicationHelper
  def policy_type(policy)
    policy.sub_policy? ? 'sub-policy' : 'policy'
  end

  def nav_link(text, link)
    recognized = Rails.application.routes.recognize_path(link)
    if recognized[:controller] == params[:controller] && recognized[:action] == params[:action]
      content_tag(:li, :class => "active") do
        link_to( text, link)
      end
    else
      content_tag(:li) do
        link_to( text, link)
      end
    end
  end

  # Data container used to generate the options for an organisations select field
  def organisations_data_container
    ContentItemFetcher.new.organisations
      .sort_by { |organisation| organisation['title'] }
      .map { |org| [org['title'], org['content_id']] }
  end

  # Data container used to generate the options for a people select field
  def people_data_container
    ContentItemFetcher.new.people
      .sort_by { |person| person['title'] }
      .map { |person| [person['title'], person['content_id']] }
  end

  def working_groups_data_container
    ContentItemFetcher.new.working_groups
      .sort_by { |working_group| working_group['title'] }
      .map { |wg| [wg['title'], wg['content_id']] }
  end

  def policies_areas_data_container
    Policy.areas.map { |policy| [policy.name, policy.id] }
  end

  # Re-orders the data container such that +selected+ ones appear first.
  def prioritise_data_container(unprioritised_container, selected)

    # extract selected names
    # don't follow this approach as select is more expensive in a big list (compared to detect)
    selected_orgs = unprioritised_container.select { |item| selected.include?(item[1]) }.map(&:first)

    # sort them
    selected_orgs.sort!


    # put them in the beggining of the list
    # the problem is that you need to remove the selected ones from the
    # unprioritised_container before adding them to the begginning of the list

    selected.reverse.each do |value|
      if item = unprioritised_container.detect { |item| item[1] == value }
        unprioritised_container.delete(item)
        unprioritised_container.unshift(item)
      end
    end



    unprioritised_container
  end
end
