require "rails_helper"

RSpec.describe EmailAlertSignupContentItemPresenter do
  describe "#exportable_attributes" do
    it "validates against the email alert signup schema" do
      presenter = EmailAlertSignupContentItemPresenter.new(FactoryGirl.create(:policy))

      expect(presenter.exportable_attributes.as_json).to be_valid_against_schema('email_alert_signup')
    end

    it "includes appropriate tags to get the subscriptions URL" do
      policy = FactoryGirl.create(:policy)
      presenter = EmailAlertSignupContentItemPresenter.new(policy)
      signup_tags = {
        "policies" => [policy.slug]
      }

      expect(presenter.exportable_attributes.as_json['details']["signup_tags"]).to eq(signup_tags)
    end

    it "includes breadcrumbs with the relevant policy" do
      policy = FactoryGirl.create(:policy)
      presenter = EmailAlertSignupContentItemPresenter.new(policy)
      breadcrumbs = [
        {
          "title" => policy.name,
          "link" => policy.base_path
        }
      ]

      expect(presenter.exportable_attributes.as_json['details']["breadcrumbs"]).to eq(breadcrumbs)
    end

    it "includes the govdelivery_title" do
      policy = FactoryGirl.create(:policy, name: "Employment")
      presenter = EmailAlertSignupContentItemPresenter.new(policy)

      expect(presenter.exportable_attributes.as_json["details"]["govdelivery_title"]).to eq("Employment policy")
    end

    it "allows the update type to be overridden" do
      policy = FactoryGirl.create(:policy)
      major_attributes = EmailAlertSignupContentItemPresenter.new(policy).exportable_attributes.as_json
      minor_attributes = EmailAlertSignupContentItemPresenter.new(policy, update_type='minor').exportable_attributes.as_json

      expect(major_attributes["update_type"]).to eq("major")
      expect(minor_attributes["update_type"]).to eq("minor")
    end
  end
end
