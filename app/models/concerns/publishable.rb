module Publishable
  extend ActiveSupport::Concern

  included do
    validates :content_id, presence: true, uniqueness: true

    before_validation on: :create do |object|
      object.slug = object.name.to_s.parameterize
      object.content_id = SecureRandom.uuid
    end

    after_save :publish!
  end

  def republish!
    publish_content_item!('minor')
    add_to_search_index!
  end

  def publish!
    publish_content_item!
    add_to_search_index!
  end

  def base_path
    "/government/policies/#{slug}"
  end

private
  def publish_content_item!(update_type='major')
    presenter = ContentItemPresenter.new(self, update_type)
    attrs = presenter.exportable_attributes
    publishing_api.put_content_item(base_path, attrs)
  end

  def publishing_api
    @publishing_api ||= PolicyPublisher.services(:publishing_api)
  end

  def add_to_search_index!
    SearchIndexer.new(self).index!
  end
end
