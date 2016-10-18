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
      description: search_description,
      link: policy.base_path,
      slug: policy.slug,
      indexable_content: "",
      people: people,
      policy_groups: working_groups,
      public_timestamp: policy.updated_at,
    }
  end

private

  def search_description
    Govspeak::Document.new(policy.description).to_text
  end

  def people
    fetched_people = policy.people_content_ids.map { |content_id| fetcher.find_person(content_id) }.compact
    get_slugs(fetched_people)
  end

  def working_groups
    fetched_working_groups = policy.working_group_content_ids.map { |content_id| fetcher.find_working_group(content_id) }.compact
    get_slugs(fetched_working_groups)
  end

  def get_slugs(items)
    items.map { |cri| cri["base_path"].gsub(%r{.*/([^/]+?)$}, '\1') }
  end

  def fetcher
    @fetcher ||= ContentItemFetcher.new
  end
end
