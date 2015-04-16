namespace :publishing_api do
  desc "Publish all Policies to the Publishing API"
  task publish_policies: :environment do
    Policy.all.map(&:publish!)
  end

  desc "Publish the Policies Finder to the Publishing API"
  task publish_policies_finder: :environment do
    require "policies_finder_publisher"

    PoliciesFinderPublisher.new.publish
  end
end
