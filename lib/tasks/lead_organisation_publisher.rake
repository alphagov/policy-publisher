namespace :publishing_api do
  desc "populate publishing api with lead organisations"
  task publish_lead_organisations: :environment do
    Policy.find_each do |policy|

      organisations_from_db = policy[:organisation_content_ids]

      links_payload = {
        links: {
          organisations: organisations_from_db
        }
      }

      lead_organisation = organisations_from_db.first

      if lead_organisation
        links_payload[:links][:lead_organisations] = [ lead_organisation ]
      end

      puts "Publishing '#{policy.name}' orgs to publishing-api"
      Services.publishing_api.patch_links(policy.content_id, links_payload)
    end
  end
end
