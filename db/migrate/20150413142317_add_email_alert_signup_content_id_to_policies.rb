class AddEmailAlertSignupContentIdToPolicies < ActiveRecord::Migration
  def change
    add_column :policy_areas, :email_alert_signup_content_id, :string
    add_index :policy_areas, :email_alert_signup_content_id, unique: true
  end
end
