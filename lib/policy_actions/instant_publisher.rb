class InstantPublisher
  def self.publish(content_id:, content_payload:, links_payload:, update_type:)
    Services.publishing_api.put_content(content_id, content_payload)
    Services.publishing_api.publish(content_id, update_type)
    Services.publishing_api.patch_links(content_id, links_payload)
  end
end
