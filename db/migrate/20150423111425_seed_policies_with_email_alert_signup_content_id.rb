class SeedPoliciesWithEmailAlertSignupContentId < ActiveRecord::Migration
  def change
    Policy.all.each do |policy|
      policy.email_alert_signup_content_id = SecureRandom.uuid
      policy.save!
    end
  end
end
