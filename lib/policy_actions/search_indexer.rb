# Adds a policy to the search index
class SearchIndexer
  attr_reader :policy

  def initialize(policy)
    @policy = policy
  end

  def run!
    Services.rummager.add_document("policy", policy.base_path, document)
  end

  def document
    {
      title: policy.name,
      description: policy.description,
      link: policy.base_path,
      slug: policy.slug,
      indexable_content: "",
      organisations: get_slugs(policy.organisations),
      people: get_slugs(policy.people),
      policy_groups: get_slugs(policy.working_groups),
      public_timestamp: policy.updated_at,
    }
  end

private
  def get_slugs(content_register_items)
    content_register_items.map {|cri| cri["base_path"].gsub(%r{.*/([^/]+?)$}, '\1') }
  end
end
