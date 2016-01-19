# Content items from the publishing-api
class ContentItemFetcher
  FIELDS = %w(content_id format title base_path)

  def organisations
    @organisations ||= Services.publishing_api.get_content_items(
      content_format: 'organisation',
      fields: FIELDS
    )
  end

  def people
    @people ||= Services.publishing_api.get_content_items(
      content_format: 'person',
      fields: FIELDS
    )
  end

  def working_groups
    @working_groups ||= Services.publishing_api.get_content_items(
      content_format: 'working_group',
      fields: FIELDS
    )
  end

  def find_person(content_id)
    people.find { |person| person["content_id"] == content_id }
  end

  def find_organisation(content_id)
    organisations.find { |organisation| organisation["content_id"] == content_id }
  end

  def find_working_group(content_id)
    working_groups.find { |wg| wg["content_id"] == content_id }
  end
end
