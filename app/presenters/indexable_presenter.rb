class IndexablePresenter

  def initialize(policy)
    @policy = policy
  end

  def indexable_attributes
    {
      title: policy.name,
      description: policy.description,
      link: id,
      indexable_content: "",
      organisations: [],
      last_update: policy.updated_at,
    }
  end

  def id
    "/government/policies/#{policy.slug}"
  end

private
  attr_reader :policy

end
