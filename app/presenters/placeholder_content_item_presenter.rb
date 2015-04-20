class PlaceholderContentItemPresenter
  attr_reader :policy

  def initialize(policy)
    @policy = policy
  end

  def exportable_attributes
    {
      format: "placeholder_policy",
      content_id: policy.content_id,
      title: policy.name,
      public_updated_at: policy.updated_at,
      locale: "en",
      update_type: "major",
      publishing_app: "policy-publisher",
      rendering_app: "finder-frontend",
      routes: [
        {
          path: policy.base_path,
          type: "exact",
        }
      ],
    }
  end
end
