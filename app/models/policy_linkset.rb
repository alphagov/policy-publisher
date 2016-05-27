class PolicyLinkset
  attr_accessor :organisation_content_ids,
                :lead_organisation_content_ids,
                :people_content_ids,
                :working_group_content_ids

  def initialize(content_id = nil)
    @organisation_content_ids = []
    @lead_organisation_content_ids = []
    @people_content_ids = []
    @working_group_content_ids = []
    
 # TODO refactor into two different methods, ie
 # def from_existing(policy)
 #   links = Services.publishing_api.get_links(policy.content_id)["links"]
 #
 #   new({
 #     organisation_content_ids: links["lead_organisations"] || [],
 #     lead_organisation_content_ids: links["organisations"] || [],
 #     people_content_ids: links["people"] || [],
 #     working_group_content_ids: links["working_groups"] || [],
 #   })
 # end

    if content_id
      links = Services.publishing_api.get_links(content_id)["links"]
      @lead_organisation_content_ids = links["lead_organisations"] || []
      @organisation_content_ids = links["organisations"] || []
      @people_content_ids = links["people"] || []
      @working_group_content_ids = links["working_groups"] || []
    end
  end

  def set_organisation_priority(lead_organisation_content_ids, supporting_organisation_content_ids)
    @lead_organisation_content_ids = lead_organisation_content_ids
    @organisation_content_ids = lead_organisation_content_ids + supporting_organisation_content_ids
  end

  def supporting_organisation_content_ids
    organisation_content_ids - lead_organisation_content_ids
  end
end
