class PublishEmailAlertSignupContentItemForAllPolicies < ActiveRecord::Migration
  def change
    Policy.all.each do |policy|
      puts "Publishing email signup content item for #{policy.name}"
      EmailAlertSignupContentItemPublisher.new(policy).run!
    end
  end
end
