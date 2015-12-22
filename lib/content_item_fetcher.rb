# Content items from the publishing-api
class ContentItemFetcher
  FIELDS = %w(content_id format title base_path)

  def self.organisations
    Services.publishing_api.get_content_items(
      content_format: 'organisation',
      fields: FIELDS
    )
  end

  def self.people
    Services.publishing_api.get_content_items(
      content_format: 'person',
      fields: FIELDS
    )
  end

  def self.working_groups
    Services.publishing_api.get_content_items(
      content_format: 'working_group',
      fields: FIELDS
    )
  end
end
