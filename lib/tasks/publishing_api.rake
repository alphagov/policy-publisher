namespace :publishing_api do
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
