require "rails_helper"

RSpec.describe ContentItemPresenter do
  let(:policy) {
    PolicyArea.new(
      name: "Tea and biscuits",
      slug: "tea-and-biscuits",
      description: "Tea and biscuits are popular among many people who live in the UK.",
      content_id: "f61106bd-fb70-4003-a85a-71e5d52bea01",
    )
  }

  let(:presenter) { ContentItemPresenter.new(policy) }

  describe "#exportable_attributes" do
    it "has fields required by the ContentStore" do
      exported_attrs = presenter.exportable_attributes
      expect(exported_attrs["base_path"]).to eq("/government/policies/#{policy.slug}")
      expect(exported_attrs["title"]).to eq(policy.name)
    end

    it "sets details hash" do
      details = presenter.exportable_attributes["details"]

      expect(details[:filter][:policies]).to match_array([policy.slug])
      expect(details[:human_readable_finder_format]).to eq("Policy Area")
    end
  end
end
