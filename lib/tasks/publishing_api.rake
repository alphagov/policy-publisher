namespace :publishing_api do
  desc "Publish all Policies to the Publishing API in reverse alphabetical order"
  task publish_policies: :environment do
    Policy.all.order("name DESC").each do |policy|
      puts "Publishing #{policy.name}"

      # Load the links from publishing-api, because we don't keep those in the
      # application database.
      policy.fetch_links!

      ContentItemPublisher.new(policy, update_type: 'republish').run!
    end
  end

  desc "Publish semi-static pages. This is run after each deploy."
  task publish: [:publish_policies_finder]

  desc "Publish the Policies Finder to the Publishing API"
  task publish_policies_finder: :environment do
    require "policies_finder_publisher"

    PoliciesFinderPublisher.new.publish
  end

  desc "Unpublish the Policy Firehose Finder to the Publishing API. Can be removed once run on production."
  task unpublish_policy_firehose_finder: :environment do
    Services.publishing_api.unpublish(
      "ccb6c301-2c64-4a59-88c9-0528d0ffd088",
      type: "redirect",
      alternative_path: "/government/policies"
    )
  end
end
