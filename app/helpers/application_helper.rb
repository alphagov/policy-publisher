module ApplicationHelper
  def policy_type(policy)
    policy.programme? ? 'policy programme' : 'policy area'
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
      map { |org| [org['title'], org['content_id']] }
  end

  def policies_data_container(excluding: [])
    Policy.where.not(id: excluding.map(&:id)).map { |policy| [policy.name, policy.id] }
  end
end
