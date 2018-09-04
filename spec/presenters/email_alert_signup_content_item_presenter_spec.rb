require "rails_helper"

RSpec.describe EmailAlertSignupContentItemPresenter do
  describe "#exportable_attributes" do
    it "validates against the email alert signup schema" do
      presenter = EmailAlertSignupContentItemPresenter.new(FactoryBot.create(:policy))

      expect(presenter.exportable_attributes.as_json).to be_valid_against_schema('email_alert_signup')
    end

    it "includes appropriate tags to get the subscriptions URL" do
      policy = FactoryBot.create(:policy)
      presenter = EmailAlertSignupContentItemPresenter.new(policy)
      expected_subscriber_list = {
        "tags" => {
          "policies" => [policy.slug]
        }
      }

      expect(presenter.exportable_attributes.as_json['details']["subscriber_list"]).to eq(expected_subscriber_list)
    end

    it "includes breadcrumbs with the relevant policy" do
      policy = FactoryBot.create(:policy)
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
      policy = FactoryBot.create(:policy, name: "Employment")
      presenter = EmailAlertSignupContentItemPresenter.new(policy)

      expect(presenter.exportable_attributes.as_json["details"]["govdelivery_title"]).to eq("Employment policy")
    end
  end
end
