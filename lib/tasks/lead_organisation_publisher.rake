namespace :publishing_api do
  desc "populate publishing api with lead organisations"
  task publish_lead_organisations: :environment do
    Policy.find_each do |policy|

      links_payload = {
        links: {
          organisations: policy.organisation_content_ids
        }
      }

      lead_organisation = policy.organisation_content_ids.first

      if lead_organisation
        links_payload[:links][:lead_organisations] = [ lead_organisation ]
      end

      puts "Publishing '#{policy.name}' orgs to publishing-api"
      Services.publishing_api.put_links(policy.content_id, links_payload)
    end
  end
end
