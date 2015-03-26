class SearchIndexer
  attr_reader :policy

  def initialize(policy)
    @policy = policy
  end

  def index!
    rummager.add_document("policy", policy.base_path, document)
  end

  def document
    {
      title: policy.name,
      description: policy.description,
      link: policy.base_path,
      slug: policy.slug,
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
