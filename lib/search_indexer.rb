class SearchIndexer
  attr_reader :policy

  def initialize(policy)
    @policy = policy
  end

  def index!
    rummager.add_document("policy", "/government/policies/#{policy.slug}", document)
  end

  def document
    {
      title: policy.name,
      description: policy.description,
      link: "/government/policies/#{policy.slug}",
      indexable_content: "",
      organisations: [],
      last_update: policy.updated_at,
    }
  end

private
  def rummager
    @rummager ||= PolicyPublisher.services(:rummager)
  end
end
