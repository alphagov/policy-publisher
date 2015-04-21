require "rails_helper"

RSpec.describe ContentItemPresenter do
  describe "#exportable_attributes" do
    it "validates against the policy schema" do
      presenter = ContentItemPresenter.new(FactoryGirl.create(:policy))

      expect(presenter.exportable_attributes.as_json).to be_valid_against_schema('policy')
    end

    it "validates against the schema when the policy has a parent policy" do
      parent_policy = FactoryGirl.create(:policy)
      presenter = ContentItemPresenter.new(FactoryGirl.create(:policy, parent_policies: [parent_policy]))

      expect(presenter.exportable_attributes.as_json).to be_valid_against_schema('policy')
    end

    it "includes an appropriate filter to filter by the policy slug" do
      policy = FactoryGirl.create(:policy)
      presenter = ContentItemPresenter.new(policy)
      filter = {
        "policies" => [policy.slug]
      }

      expect(presenter.exportable_attributes.as_json['details']["filter"]).to eq(filter)
    end

    it "includes linked organisations" do
      content_id = SecureRandom.uuid
      policy = FactoryGirl.create(:policy, organisation_content_ids: [content_id])
      attributes = ContentItemPresenter.new(policy).exportable_attributes.as_json

      expect(attributes["links"]["organisations"]).to eq([content_id])
    end

    it "includes linked people" do
      content_id = SecureRandom.uuid
      policy = FactoryGirl.create(:policy, people_content_ids: [content_id])
      attributes = ContentItemPresenter.new(policy).exportable_attributes.as_json

      expect(attributes["links"]["people"]).to eq([content_id])
    end

    it "includes related policies" do
      related_policy = FactoryGirl.create(:policy)
      policy = FactoryGirl.create(:policy, related_policies: [related_policy])
      attributes = ContentItemPresenter.new(policy).exportable_attributes.as_json

      expect(attributes["links"]["related"]).to eq([related_policy.content_id])
    end

    it "includes the linked email alert signup" do
      policy = FactoryGirl.create(:policy)
      attributes = ContentItemPresenter.new(policy).exportable_attributes.as_json

      expect(attributes["links"]["email_alert_signup"]).to eq([policy.email_alert_signup_content_id])
    end

    it "doesn't add nation_applicability if the policy applies to all nations" do
      policy = FactoryGirl.create(:policy)
      attributes = ContentItemPresenter.new(policy).exportable_attributes.as_json
      expect(attributes["details"]).not_to have_key("nation_applicability")
    end

    it "returns a list of applicable nations if there are inapplicable nations" do
      policy = FactoryGirl.create(
        :policy,
        northern_ireland: false,
        scotland: false,
        wales: false,
      )

      attributes = ContentItemPresenter.new(policy).exportable_attributes.as_json
      nation_applicability = attributes["details"]["nation_applicability"]
      expect(nation_applicability["applies_to"]).to eq(["england"])
      expect(nation_applicability["alternative_policies"].length).to eq(0)
    end

    it "returns a list of alternative policies for other nations if there are alternative policies" do
      policy = FactoryGirl.create(
        :policy,
        northern_ireland: false,
        northern_ireland_policy_url: "https://www.example.ni",
        scotland: false,
        scotland_policy_url: "http://www.example.scot",
        wales: false,
        wales_policy_url: "http://example.wales",
      )

      attributes = ContentItemPresenter.new(policy).exportable_attributes.as_json
      nation_applicability = attributes["details"]["nation_applicability"]
      expect(nation_applicability["applies_to"]).to eq(["england"])
      expect(nation_applicability["alternative_policies"].length).to eq(3)
      expect(nation_applicability["alternative_policies"].first["nation"]).to eq("northern_ireland")
      expect(nation_applicability["alternative_policies"].first["alt_policy_url"]).to eq("https://www.example.ni")
    end

    it "allows the update type to be overridden" do
      policy = FactoryGirl.create(:policy)
      major_attributes = ContentItemPresenter.new(policy).exportable_attributes.as_json
      minor_attributes = ContentItemPresenter.new(policy, update_type='minor').exportable_attributes.as_json

      expect(major_attributes["update_type"]).to eq("major")
      expect(minor_attributes["update_type"]).to eq("minor")
    end
  end
end
