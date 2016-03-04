# Content items from the publishing-api
class ContentItemFetcher
  def organisations
    @organisations ||= Services.publishing_api.get_linkables(document_type: 'organisation')
  end

  def people
    @people ||= Services.publishing_api.get_linkables(document_type: 'person')
  end

  def working_groups
    @working_groups ||= Services.publishing_api.get_linkables(document_type: 'working_group')
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
