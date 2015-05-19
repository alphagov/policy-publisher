namespace :publishing_api do
  desc "Publish all Policies to the Publishing API in reverse alphabetical order"
  task publish_policies: :environment do
    Policy.all.order("name DESC").each { |policy|
      puts "Publishing #{policy.name}"
      Publisher.new(policy).publish!
    }
  end

  desc "Publish the Policies Finder to the Publishing API"
  task publish_policies_finder: :environment do
    require "policies_finder_publisher"

    PoliciesFinderPublisher.new.publish
  end
end
