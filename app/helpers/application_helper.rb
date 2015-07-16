module ApplicationHelper
  def policy_type(policy)
    policy.programme? ? 'policy programme' : 'policy'
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
    PolicyPublisher.services(:content_register).organisations.
      map { |org| [org['title'], org['content_id']] }
  end

  # Data container used to generate the options for a people select field
  def people_data_container
    PolicyPublisher.services(:content_register).people.
      map { |person| [person['title'], person['content_id']] }
  end

  def working_groups_data_container
    PolicyPublisher.services(:content_register).working_groups.
      map { |wg| [wg['title'], wg['content_id']] }
  end

  def policies_areas_data_container
    Policy.areas.map { |policy| [policy.name, policy.id] }
  end

  # Re-orders the data container such that +selected+ ones appear first.
  def prioritise_data_container(unprioritised_container, selected)
    selected.reverse.each do |value|
      if item = unprioritised_container.detect { |item| item[1] == value }
        unprioritised_container.delete(item)
        unprioritised_container.unshift(item)
      end
    end

    unprioritised_container
  end
end
