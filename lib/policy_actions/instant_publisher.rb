class InstantPublisher
  def self.publish(content_id:, content_payload:, links_payload:, update_type:)
    publishing_api = PolicyPublisher.services(:publishing_api)

    publishing_api.put_content(content_id, content_payload)
    publishing_api.publish(content_id, update_type)
    publishing_api.put_links(content_id, links_payload)
  end
end
