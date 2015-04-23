class AddEmailAlertSignupContentIdToPolicies < ActiveRecord::Migration
  def change
    add_column :policies, :email_alert_signup_content_id, :string
    add_index :policies, :email_alert_signup_content_id, unique: true
  end
end
