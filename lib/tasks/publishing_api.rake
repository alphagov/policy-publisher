namespace :publishing_api do
  desc "Publish all Policies to the Publishing API in reverse alphabetical order"
  task publish_policies: :environment do
    Policy.all.order("name DESC").each do |policy|
      puts "Publishing #{policy.name}"

      # Load the links from publishing-api, because we don't keep those in the
      # application database.
      policy.fetch_links!

      Publisher.new(policy).publish!
    end
  end

  desc "Publish the Policies Finder to the Publishing API"
  task publish_policies_finder: :environment do
    require "policies_finder_publisher"

    PoliciesFinderPublisher.new.publish
  end

  desc "Publish the Policy Firehose Finder to the Publishing API"
  task publish_policy_firehose_finder: :environment do
    require "policy_firehose_finder_publisher"

    PolicyFirehoseFinderPublisher.new.publish
  end
end
