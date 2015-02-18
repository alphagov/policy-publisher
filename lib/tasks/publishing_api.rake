namespace :publishing_api do
  desc "Publish all Policies to the Publishing API"
  task publish_policies: :environment do
    PolicyArea.all.map(&:save)
    Programme.all.map(&:save)
  end
end
