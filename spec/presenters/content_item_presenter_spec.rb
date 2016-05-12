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

    it "turns Govspeak to HTML when exporting" do
      policy = FactoryGirl.create(:policy)
      policy.description = "_This_ is some [Govspeak](https://www.gov.uk)."
      presenter = ContentItemPresenter.new(policy)

      expected_html = "<p><em>This</em> is some <a href=\"https://www.gov.uk\">Govspeak</a>.</p>\n"

      expect(presenter.exportable_attributes.as_json["details"]["summary"]).to eq(expected_html)
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

    it "includes the internal name if the policy is a sub-policy" do
      policy = FactoryGirl.create(:policy)
      expect(ContentItemPresenter.new(policy).exportable_attributes[:details]).not_to have_key(:internal_name)

      sub_policy = FactoryGirl.create(:sub_policy, parent_policies: [policy])
      expect(ContentItemPresenter.new(sub_policy).exportable_attributes[:details][:internal_name]).to eq("#{sub_policy.name}: #{policy.name}")
    end

    it "includes the emphasised_organisations" do
      policy = create(:policy)
      policy.lead_organisation_content_ids = [1, 2, 3]

      payload = ContentItemPresenter.new(policy).exportable_attributes

      expect(payload[:details][:emphasised_organisations]).to eql([1, 2, 3])
    end
  end
end
